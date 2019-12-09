---
title: "软件工程实践之平滑发版"
date: 2019-12-09T23:39:28+08:00
aliases:
  - /software-engineering-gracefully-upgrade
---

软件工程实践系列文章，
会着重讲述实际的工程项目中是如何协作开发软件的。
本文主要介绍了如何无中断地发布版本。

<!--more-->

## outline

本文包括以下内容：

- why
- how: 其实平滑发版大体可以分为两部分。
  - service: 服务层做好切换管理就行。
  - database: 数据库层就是标准操作。
- example: 举个实际的栗子。
- conclusion

## why: 为什么要平滑发版？

[ldsink][ldsink] 说过以前他在百姓网的时候，
他们一直保持的实践就是“随时都准备好发版”，
这样不仅能保持功能上线的敏捷度，
还准备好了应对各种变化。

当时我们的一体化服务每次发版都要停服几秒钟，
几秒钟对应的就是用户触发的一堆 5XX 网络错误。
更不用提发版更频繁的开发测试环境，
前端爸爸们经常惊呼：
“诶？服务器 502 了！诶，我刷新一下又好了……”

后来在我认真研学了以后发现，
平滑发版其实是一个非常普世的话题，
任何涉及网络流量分发、请求逻辑处理的服务都会有这部分功能。

平滑发版的英文是 `gracefully upgrade/reload/restart`,
常用的工具都会对平滑发版的流程有完善的支持，
用工具名直接搜索就行了，比如 `nginx gracefully upgrade` 或者 `k8s gracefully upgrade`。

为什么要平滑发版呢？
其实核心目的就一个：
防止发版带来的服务中断。

## how: 如何做到平滑发版？

在实际工程中，
大部分的 web 服务本质都是从外部接受请求，
从数据库查询、处理数据返回。
本片中就以这个逻辑，
按 service/database 的平滑发版来逐个介绍。

### service: 业务层的平滑发版

我们团队后端语言框架用的是 python/django，
详细情况在前文《软件工程实践之 django/python》中有介绍。
我们目前的网络链路是
_(云负载均衡) -> (k8s-ingress-controller) -> k8s-pod(nginx+uwsgi)_

云负载均衡跟 k8s-ingress-controller (目前用的是 kong) 的变动都不会太频繁，
就不过多赘述。
每次发版变动的都是业务服务，在前面的链路中指的就是 k8s-pod(nginx/uwsgi)。

不论是 k8s/docker/systemctl/supervisord/pm2,
他们通用的逻辑是系统信号 (Signals)。

| Signal  | x86 |
|---------|-----|
| SIGHUP  |  1  |
| SIGINT  |  2  |
| SIGQUIT |  3  |
| SIGKILL |  9  |
| SIGTERM |  15 |
> part of unix signal numbers

以 k8s 为例，当旧的 pod 被终止时，k8s 执行的具体操作如下：

1. 发送 `SIGTERM` 信号，然后等待最多 `terminationGracePeriodSeconds(default=30)` 秒
2. 假如等待过程中，服务停了，那就做其它终止操作
3. 假如等待过程中，服务没停，那么就发送一个 `SIGKILL` 信号

一般来说，标准的框架实现都会支持 `SIGTERM` 与 `SIGKILL` 的语义，
但具体的额外自定义逻辑就需要自己去实现把控了。

业务层确保请求不中断，
需要正确处理信号。

### database: 数据库层的平滑发版

数据库层会涉及到发版变动，
主要可以分为数据的变动、结构的变动。
**核心的处理方法是双写**。

先讲一下关于数据变动的双写。

比如我们以前有个字段A，
存储的是布尔值 true/false,
后来含义变丰富了要改成枚举值 0/1/2/3。
那么整个流程得是：

1. 增加默认为空的枚举值字段B。
2. 第一次发版引入双写，代码逻辑中涉及字段A的写入逻辑，以同样的逻辑增加对字段B的写入。
3. 清洗数据，把所有字段A的值以同样逻辑洗到字段B里。
4. 第二次发版摘除双写，代码逻辑中涉及字段A的读取逻辑，全部以字段B替代。
5. 确定正常以后，下掉字段A。

2~4 的这一步是以双写的方式处理兼容，
持续时长会因为具体的情况而相差很大：
可能 10 分钟就双写完了，
也有可能因为要给清洗大量数据留足时间而持续数天。

再看一下关于结构变动的双写，
核心逻辑跟上面的 1/2/3/4/5 套路五步是一样的。

- 增加字段：这个很简单，增加完字段以后再发版即可。
- 删除字段：这个也很简单，发版摘除相关逻辑以后再删除即可。
- 修改字段：假如是不兼容的改动，应当以增加新字段+双写+删除旧字段的逻辑来处理。

数据库层确保请求不中断，
需要以双写保证兼容。

## example: 举个实际的栗子

我们的 django 服务是以 nginx+uwsgi 的方式起来的，
nginx/uwsgi 本身对 SIGTERM/SIGKILL 语义有着良好的支持。
但同一个 pod 的情况下经常会出现 race condition，
nginx 有时会比 uwsgi 终止的更早，
最终导致请求中断的问题。

网上的老哥们也遇到过类似的问题，
解决方法也简单地有点滑稽：
[加点 sleep][sleep-in-k8s]

```
container:
  name: nginx
  lifecycle:
    preStop:
      exec:
        command: ["sh", "-c", "sleep 10 && kill -s HUP 1"]
```

除了一般的服务层跟数据库层，
我们还用到 celery 做了异步 worker。
celery 对平滑发版的支持不算特别好，
所以像[社区里提的一样][signal-in-celery]，
自己在 task 层面处理信号。

## conclusion

总的来说，工程上实现平滑发版（无中断发版）核心思想是：

- 服务层：处理好系统信号。
- 数据库：用双写保持兼容性。
- 其它：确保链路上的每一点都是无中断的，才能达成真正的平滑。

通过这么一系列操作，
我们就可以轻松地做到用户（包括拼命人肉 DDOS 测试环境的前端爸爸们）感知不到我们在发版，
最终达成那句“随时都准备好发版”的状态。

当然了，
随时发版到此时也只是技术层面的可行，
并不是意味着实际工作中真的会每时每刻都发版 :)

毕竟软件工程不仅牵涉软件技术，还有人的工程呀。

（完）


[ldsink]: https://ldsink.com/
[sleep-in-k8s]: https://github.com/kubernetes/ingress-nginx/issues/322#issuecomment-298016539
[signal-in-celery]: https://github.com/celery/celery/issues/2700
