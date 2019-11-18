---
title:     "没错，DNS TTL 字段就是骗你的"
date:      "2019-10-29 21:49:42"
aliases:
  - /stupid-dns-ttl
---

> By design,
> the Internet core is stupid,
> and the edge is smart.

<!--more-->

## 引子

前几天在网上冲浪的时候，
看到了一篇讲 DNS 的宝藏文章：
[DNS TTL Violations in the Wild][dns-ttl-violation].

之所以对我来说是宝藏文章，
因为在读了第一段以后，
我就发现了一个我习以为常的认知其实在实际是错误✖的：
*业界都会遵守 DNS 的 TTL 超时逻辑。*

然而实际上是：
**业界都知道 DNS 的 TTL 超时逻辑，但不一定这么实现。**


## 事件

前几周我们出了个 Bug,
影响了整个开发、测试环境。

我们有很大一块的业务是跟微信做各类 py 交易，
[微信要求说我们给个回调域名][component-verify-ticket]，
每 10 分钟会推送一个凭证，
我们要用微信最新的凭证去调他们的接口。

最早我们给微信配的回调域名背后是个 AWS ELB,
这是一个亚马逊云上面的旧版负载均衡；
后来我们打算换成新版负载均衡 AWS ALB。

这个操作就很简单嘛，
到 DNS 服务商里看了一下，
微信回调的域名解析 TTL 是 600 秒，
又是开发测试环境；
于是我们直接把解析改到了新版负载均衡上，
~~（出于省钱的想法）~~顺手还把旧的负载均衡给删了。

哦豁。
微信一天都没有给我们推授权凭证。
于是我们开发测试环境的微信功能挂了一天。

有的时候开发测试环境出问题，
会跟生产环境同样煎熬。
因为你会发现你身边的同事，
每隔 10 分钟就会问你：
“弟啊，微信好了没有？”


## 疑问

在改 DNS 的 86400 秒以后，
微信的凭证又成功地持续给我们推送了。

根据现象判定是 DNS 的问题以后，
一边在心里鄙视微信，
一边也产生了疑问：
“不科学啊，DNS 这么基础的服务，怎么会出 bug 呢？”

这就回到了本文开头讲的：
业界都知道 DNS 的 TTL 超时逻辑，但不一定这么实现。

每一条 DNS 记录都由两部分数据组成：
什么域名应该指向什么目的地？
我的有效时间是多久？
而这两部分数据会以互联网特有的树状结构层叠而上，盘织交错。
在终端进行 DNS 寻址时，
链路上的任何一个 DNS 服务器都可以实现一套标准或是非标的逻辑。

对于 TTL 这个值，
只有三种实现的逻辑：

1. 缓存时间等于 DNS TTL 时间。
2. 缓存时间小于 DNS TTL 时间。
3. 缓存时间大于 DNS TTL 时间。


## 世界

要我来写域名服务器的逻辑的话，
不出意外我会严格按照定义来实现。
当然，根据性能、时间、空间的限制，
最终实现出来会有几秒的误差，
不过这不关键。

关键的是，[有不少人觉得 DNS 目前的设计是有缺陷的][state-manage]。
而作为整个互联网的底层构架，
不论是要提升还是替换 DNS 目前的逻辑，
都是一个非常巨大的工程。
当然，这也更吸引工程师为此献身了。

于是，当今现实世界里的域名解析，
就不是完全按照“缓存时间等于 DNS TTL 时间”来实现的。

- 当缓存时间小于 DNS TTL 时间时
  - 主要争议点在与这个会给上游服务器带来更大的解析压力
  - 高频解析也意味着更多的带宽、网费支出
  - 但这种情况不会伤害终端用户
- 当缓存时间大于 DNS TTL 时间时
  - 主要的问题在于，这会让用户访问到错误的服务器
  - 这不仅会带来逻辑错误，还会有潜在的安全隐患
  - 在本文最开始出现的问题，其实就是微信的 DNS 链路上出现了缓存过旧的问题
  - 好处可能就是在解析费上不用交那么多钱了(x


## 总结

总的来说，DNS TTL 是一个在互联网基础设施中广泛使用的约定。
但是现实世界中也会有很多非标的实现。
由于 DNS 的特殊性，每一个非标的域名商都会影响一大片他们能触达的用户。
所以在我们操作 DNS 时，要优雅的解决问题就也得把他们给考虑进来。

工程上的问题就是这样，
既有理论的优雅，
又有凡人的愚蠢，
也有分布式的智慧。

> By design,
> the Internet core is stupid,
> and the edge is smart.

（完）

[dns-ttl-violation]: https://labs.ripe.net/Members/giovane_moura/dns-ttl-violations-in-the-wild-with-ripe-atlas-2
[component-verify-ticket]: https://developers.weixin.qq.com/doc/oplatform/Third-party_Platforms/Authorization_Process_Technical_Description.html
[state-manage]: https://mailarchive.ietf.org/arch/msg/dnsop/zRuuXkwmklMHFvl_Qqzn2N0SOGY/?qid=ff8e732c964b76fed3bbf333b89b111f
