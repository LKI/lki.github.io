---
title:     "[轶事] 为什么 requests 不是 python 标准库？"
date:      "2019-10-30 22:32:20"
aliases:
  - /anecdote-why-requests-not-standard
---

前几年一次跟耗子哥聊天，
他说：“你终有一天会从 stackoverflow 上找 bugfix,
进化到从 github issue 里找 bugfix.”
一语成谶。

<!--more-->

## 头部注释

我非常喜欢[@灵剑 说的这么一段话][why-jdk-6]：

> 软件维护有两种截然不同的思路：
> 一种是所有的依赖都追踪最新版，
> 一旦出最新版立即开始试用；
> 另一种是所有的依赖都选择一个不会变的固定版本，
> 能不升级就不升级。

看见软件的新陈代谢，给写代码的我带来了无穷的热爱与动力，
同时也给我带来了很多 github issues...

代码是人写的，bug 也是人写的，bugfix 也还是人写的，
github issue 的文字里也充满了各种各样有血有肉的充满既视感的评论。
issue 的文字虽然隔着时间空间上的距离，
但就像 [xkcd 979 - wisdom of the ancients][xkcd-979] 表达的那样，
有些情绪就是亘古不变的。

![wisdom-of-the-ancients][wisdom-of-the-ancients]

在工作中 debug 的时候，
对于具体的 issue,
同事们都留下过很多精彩的讨论。

鉴于这样，
我决定开辟一个“轶事”的专栏，
专门来讲一讲那些好玩的 issue.


## 为什么 requests 不是 python 标准库？

> 原文地址:
> [https://github.com/psf/requests/issues/2424][psf-requests-2424]

[Kenneth Reitz][kenneth] 是一个业界知名的程序员，
很多人了解他可能是因为[他从两百多斤的胖子变成一个超帅的玩摄影的程序员][kenneth-story]，
其实专业过硬的他是写出过 [python-requests][python-requests], [httpbin][httpbin] 等好用的工具库的。

requests 这个库重要到什么程度呢？
根据目前可以公开的情报看到，
GitHub 上的引用数高达 `389k`，
是 python 语言下引用数最高的库。

于是很自然的，我就产生了这样的疑问：
“为什么 requests 不是 python 标准库呢？”
作为项目的主开发，
Kenneth 在 2015 年初，
还在 python 3.5 的年代就向社区抛了一个问题：
“假如 requests 要加入 python 3.5 标准库，你们有什么想法吗？”

的确，一个库进标准库是有利有弊，要经过社区讨论的。
所以其实我的问题应该要改一个字，
从“为什么 requests 不是 python 标准库？”
改成“为什么 requests 不进 python 标准库？”

整串讨论看下来，基本是有这么几个意见：

- 优势是
  - 降低使用成本：让很多小白也能直接上手用标准库的了。
  - 扩大使用范围：很多只依赖于标准库的项目，也能用上 requests 了。
- 劣势是
  - 开发流程问题：标准库的严格流程，跟社区开发的流程完全不一样，最终可能导致开发者流失。
  - 依赖问题：现有的库依赖了不少证书之类的文件，在进标准库的过程中需要大重构。
  - 进化速度问题：进了标准库以后，接口跟实现就会固化，很难随着外部世界改变而快速变化到最好的状态。
  - 其它历史问题：以前的 urllib 库为了兼容其实已经很臃肿了，也是需要重构的。

总的来说，
社区的反对意见跟忧虑会更大一些，
更原汁原味的评论大家可以看一下原串。

整个讨论中还有几个我感兴趣的点：

- @Lukasa 在串首来了个起手式：“先问一下几个大佬，他们的看法是怎么样的。”
  然后 at 了 `@shazow @kevinburke @dstufft @alex @sigmavirus24` 这五个人。
  里面我只知道 alex 是写 `cryptography` 的，其它人其实都可以认识一下。
- 串讨论到一半的时候 `@dcramer` 留了些关于“我只用标准库依赖”的评论，
  然后留下一句 `not sure what you're all bitching about` 就跑了…
  我就不敢这么放肆...
- Kenneth 在 requests 库的文档中曾写过这么一句话：
  `Essentially, the standard library is where a library goes to die.`
  结果就在讨论过程中多次被揪出来“打脸”质疑了。
  （其实还好，设计哲学是可以设计的嘛）
- [今年四月也有个老哥 @4evermaat 抛了这个问题][psf-requests-5057]，
  他在看完四年前的讨论以后，留下了这么一句感慨：
  `I didn't realize there was so much politics in getting a module included in the stdlib.`

在讨论结束过后四年的现在，
`requests` 库依然以一个独立的社区项目生机勃勃地新陈代谢着，
python 3.5 以后也增加了标准库 `urllib.request` 支持一部分核心功能。

代码既是人设计的，
也是给人用的。
它们背后的故事，
也是程序内在逻辑的一部分。
这部分逻辑曾经在一个个讨论串里存活着，
最终也让代码更加鲜活地呼吸着、代谢着、生存了下去。

（完）


[why-jdk-6]: https://www.zhihu.com/question/30137699/answer/476916096
[xkcd-979]: https://xkcd.com/979/
[wisdom-of-the-ancients]: https://imgs.xkcd.com/comics/wisdom_of_the_ancients.png
[psf-requests-2424]: https://github.com/psf/requests/issues/2424
[kenneth]: https://github.com/kennethreitz
[kenneth-story]: https://zhuanlan.zhihu.com/p/20346580
[psf-requests-5057]: https://github.com/psf/requests/issues/5057
[python-requests]: https://github.com/psf/requests
[httpbin]: https://github.com/postmanlabs/httpbin
