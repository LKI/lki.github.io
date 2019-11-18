---
layout: post
title: 破案·Sentry迷云
date: '2018-03-22 20:14:08'
aliases:
  - /solve-a-sentry-case
comments:
  - author:
      type: github
      displayName: shidenggui
      url: 'https://github.com/shidenggui'
      picture: 'https://avatars0.githubusercontent.com/u/5035364?v=4&s=73'
    content: >-
      &#x770B;&#x4E86;&#x8FD9;&#x7BC7;&#x6587;&#x7AE0;&#xFF0C;&#x5728;&#x6211;&#x4EEC;&#x516C;&#x53F8;&#x4E5F;&#x63A8;&#x5E7F;&#x4F7F;&#x7528;
      sentry &#x4E86;
    date: 2018-04-04T10:19:26.264Z

---

作为程序员，
日常开发中经常会出现一些“不科学”的事情，
这种时候也是“破案”的好时机：
让我们来用科学，解释不科学。

<!--more-->


## 起

又是平凡的一天，
坐成一排的程序员们正在噼里啪啦地写代码。
不知不觉间 deadline 逼近了，
想到这点，
大家不禁紧张地噼里啪啦地写代码。

突然，[旭总][mia503]眉头一皱，发现事情并不简单：
“我总感觉这几天 Sentry 的响应速度变慢了。”

> Sentry, 英文单词直译是哨兵（漫威宇宙里最强者之一）。
> 也是一个非常好用的异常监控/收集/管理软件，
> 官网可以参见 sentry.io
>
> 我司用 Sentry 做了各端的错误收集，
> 大家养成了一出错先看 Sentry 堆栈分锅的习惯。

于是紫月就例行公事地看了一眼 Sentry Stats,
紫月觉得事情很简单：
“拉总你看看你的推送啊！”

> [拉总][lxkaka]，绰号来源于 ID: lxkaka.
> 因为跟我们支付供应商拉卡拉 (lakala) 巨像而得名。
>
> 拉总在我司做后端，
> 负责过会员数据、平台监控、推送系统的实现。

![stats][stats]

跑过来看着紫月屏幕里 Sentry Stats 的数据，
拉总感到一脸懵逼：
“不应该啊，推送系统怎么能报这么多错呢？”


## 承

回到座位的拉总研究了一会儿，
惊呼道：
“我们是不是换过测试环境的 MongoDB 地址啊？”

旭总一脸鄙视：
“没换，要换也是两个月以前换的。”

紫月笑着调戏拉总：
“不会你的代码跪了两个月才发现吧？”

拉总赶快说：
“不可能不可能，我再看看。”

过了十分钟，
拉总二脸懵逼地站起来了，
十分迷惑地 Pub 了一句：
“这不科学啊，测试环境是好的啊。”

于是大家凑在一起，
整理出了目前几个已知事实：

* Sentry 不停地在接受测试环境的推送系统 (zaihui-push) 的报错。
* 报错内容是 MongoDB 访问地址不对。
* 两个月以前我们换过测试环境的 MongoDB 。
* 但是代码级别上，测试环境用的 MongoDB 配置是正确的。

也就是说：
我们以为我们代码是正确的，
但是监控观察到代码一直在报错！

这很 (bu) 神 (ke) 奇 (xue) 。

于是我们决定破案一下。

首先，拉总检查了一下测试环境的正确性。
拉总把推送系统的 docker 都关了，
但 Sentry 还是一直收到报错，
这说明**报错源不是测试环境**。

[俊儒][hulucc]指出 Sentry 说不定可以看到源 IP，
于是紫月尝试观测了一下，
IP 是没观测到，但是观测到了 Server Name。

![tags][tags]

`ea064a694da5` 这个12位的16进制数字是典型的 Docker Container ID ！

所以大家马上想到了暴力的破解方法：
把内网的所有 Docker Container ID 都找出来。

> 我司的测试/生产环境都在内网环境中，
> 只能通过入口机器 (gateway) ssh 到机器上。
> 为了方便运维，
> 内网机器都在 ssh config 里配上了名称。

于是紫月在入口机上执行了一段 bash 脚本，
把所有内网上的 Docker Container ID 都找了出来：

```
cat ~/.ssh/config | grep -G '^Host' | cut -d' ' -f2 | xargs -I{} ssh {} "docker ps" >> dockers_container.log
```

命令跑完以后，
我们打开输出文件，
激动地发现：
**报错源不在内网里**！


## 转

一下子事情僵住了，
大家的头绪离散到了好几个方面：

* 能不能模拟 MongoDB 的地址，然后抓包请求？
* 能不能在 Sentry 信息中翻到 IP 地址？
* 能不能通过 Docker Container ID 找到对应的机器？

经过思考以后，
大家总结出破案的关键在于整个网络调用：
我们只要捋一遍服务器的网络关系、调用路径，
就可以找到破案点！

问题一下子就定位到了内部系统的 Load Balancer 上。

> 我司隔离了生产环境和内部系统（比如 GitLab/Sentry 等）
> 类似于生产环境的入口机器 (gateway)
> 我们内部系统的流量入口也是我们用 nginx 自己搭的。

于是我们登上了内部系统的 nginx,
找到了 nginx access log,
整个文件大概有10万行。

```
...
42141 59.78.3.25 - - [22/Mar/2018:22:09:07 +0800] "POST /api/450/store/ HTTP/1.1" 200 41 "-" "raven-python/6.3.0" "-"
42142 59.78.3.20 - - [22/Mar/2018:22:09:07 +0800] "POST /api/355/store/?sentry_version=7&sentry_client=raven-js%2F3.22.3& HTTP/1.1" 200 41 "Mozilla/5.0 (Linux; Android 8.0; DUK-AL20 Build/HUAWEIDUK-AL20; wv) Mobile Safari/537.36 MicroMessenger/6.6.5.1280" "-"
42143 59.78.3.24 - - [22/Mar/2018:09:33:08 +0800] "POST /api/452/store/ HTTP/1.1" 400 62 "-" "SharpRaven/2.2.0.0" "-"
...
```

问题又来了：
要怎么在这数万行形态各异的 log 中，
找到哪一条是推送系统的报错，
从而找到报错源的 IP 呢？

可以通过 Sentry Endpoint,
也可以通过 Raven 的版本。
比如上述 log 中的三条信息，
分别是 Python/JavaScript/C# 向 Sentry 发送的错误信息。

推送系统用的包是 [raven==6.3.0][ravern],
于是我们就从中晒出来了真正的 IP：
59.78.3.25 ！
（本条 IP 已打码）

大家兴奋地都站了起来。
因为不是自己推送系统环境没配对之类的锅，
拉总也如释重负/火上浇油地喊道：
“破案了破案了！快看看这个IP是谁的！”


## 合

上网定位了一下，
发现这个 IP 是上海市的，
俊儒怀疑道：
“这怕不是就是我司办公室的流量出口？”

于是我们查了一下我们现在的出口 IP：

```
> curl -s httpbin.org/ip
{
  "origin": "59.78.3.25"
}
```

顿时空气有点寂静，
因为目前的事实是这样的：

* 拉总确认过他开发的推送系统没有报错。
* 大家追溯下来，报错源就在我们办公室。
* 报错源藏在某个人电脑的 docker 里面。

那么问题来了：
究竟哪个人会 clone 推送系统的代码，
并且在自己的电脑上用 docker 跑起来呢？
那就只可能是开发者**拉总本人**。

大家围到了紧张的拉总的身后，
看着他敲下了 `docker ps` 命令：

```
> docker ps
CONTAINER ID        IMAGE           ...
ea064a694da5        zaihui-push     ...
```

破案了！

拉总想了想，猜测说：
他大概是几天前本机调试了一下推送，
忘了关了。

那么真的如他所说是几天前吗？
大家打开了 Sentry：

![frequency][frequency]

数据无情地还原了真相：
两个月以前就开始报错了，
也就是按旭总的记忆，
从我们换了测试环境的 MongoDB 开始。

看着最后原来是拉总自己电脑搞的乌龙，
大家也是爆笑了一圈，
旭总顺带还调侃拉总：
“你的 Mac 电脑也是牛逼啊，开着几个 docker 都不卡的。”

后来看着 Sentry 的错误频率图，
大家又疯狂地笑了一圈拉总：
“拉总，这个 Sentry 报错早十晚八，做五休二，
可真能反映你的上班时间~”

![hours][hours]

![weeks][weeks]

事情的最后，
紫月从柳总桌子上翻出了门把手的“拉”和“推”两个字，
放在了拉总的桌子上：
“拉总，好吧，经此一役，
你也是我们的推总了。”

（完）


[mia503]: https://github.com/MIA503
[stats]: /assets/pics/cases/sentry_stats.jpg
[lxkaka]: http://lxkaka.wang/
[hulucc]: https://github.com/hulucc
[tags]: /assets/pics/cases/sentry_tags.jpg
[raven]: https://pypi.python.org/pypi/raven
[frequency]: /assets/pics/cases/sentry_frequency.jpg
[hours]: /assets/pics/cases/sentry_hours.jpg
[weeks]: /assets/pics/cases/sentry_weeks.jpg

