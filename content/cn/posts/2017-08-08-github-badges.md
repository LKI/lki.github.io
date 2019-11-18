---
title:     "GitHub上的小标签有什么好玩的"
date:      "2017-08-08 23:10:01"
aliases:
  - /github-badges
---

GitHub很多项目主页都会放上好玩的小标签（GitHub Badges），
这次我们也来玩点表面功夫。

<!--more-->

## 首先，我们要有一个项目

前阵子[靖哥哥][jkzing]口嫌体正直地吐槽了一下[lowdb][lowdb]：

> 这个lowdb，
> 好用是好用，
> 但是也太low了吧...

我十分好奇，
跑去看了看[lowdb][lowdb]的介绍：

> 这是一个 JSON 格式的微型数据库。

诶，微型诶，感觉萌萌哒。
那 Python 有没有对标的库呢？
有，那就是[tinydb][tinydb]~

> tinydb 大概只有1200行源代码，以及1000行测试。

啥？！这还tiny呢？
怕是18级的tiny吧？

于是我们决定，
**要有一个比tinydb还tiny的，比lowdb还要low的数据库。**

起名字顿时是个问题。
既然犹豫不定，
[那就选择原谅他吧][forgive-meme]~
于是又一个轮子诞生了：

[原谅数据库(hui-z/ForgiveDB)][forgivedb]

![readme][readme]


## GitHub Badges

忽略README里对项目本身的吹捧，
Logo下面那一长串绿绿的小标签，
就是Badges啦~
[由于程序员一般都在GitHub上活动][github]，
所以大家也习惯把这些叫做是GitHub Badges
（即使在别的地方也可以用到它们）

本质上这些小标签就是能点的图片，
比如用 [Markdown 语法][markdown]可以这么写：

```markdown
[![ForgiveDB](https://img.shields.io/badge/ForgiveDB-HuiZ-brightgreen.svg)](https://github.com/hui-z/ForgiveDB)

*这么一长串实际上是 Markdown 里图片的语法，加超链接的语法组合成的*

![图片的语法](https://img.shields.io/badge/ForgiveDB-HuiZ-brightgreen.svg)

[超链接的语法](https://github.com/hui-z/ForgiveDB)
```

上面一串就会变成这样子：

[![ForgiveDB](https://img.shields.io/badge/ForgiveDB-HuiZ-brightgreen.svg)](https://github.com/hui-z/ForgiveDB)

*这么一长串实际上是 Markdown 里图片的语法，加超链接的语法组合成的*

![图片的语法](https://img.shields.io/badge/ForgiveDB-HuiZ-brightgreen.svg)

[超链接的语法](https://github.com/hui-z/ForgiveDB)


## 各种 Badges

具体来看，
我们在 [ForgiveDB][forgivedb] 里用到的标签有这些：

* [**shields.io**][shields.io].
这个值得单独拎出来讲，
因为他们是个专门做 Badges 的网站，
上面图还是 SVG 矢量图，
在任何分辨率屏幕下都不会模糊。
假如我们想挑各种各样奇怪的 Badges,
（比如 star 项目的数量、
issue 关闭的数量、
npm, pypi, nuget的版本、
甚至是自定义任意字符）
都可以上[shields.io][shields.io]找找看。

* [**PyPI**][pypi].
这个是 Python 官方的包仓库，
[shields.io][shields.io]也支持版本自动嗅探。
低于 1.0.0 版本的好像还会变成屎黄色…

* [**pyup.io**][pyup].
这个服务很好玩，
授权以后它会自动检测你的 requirements 是不是最新的。
假如一有更新，
[pyup-bot 会直接给项目提一个 Pull Request...][pyup-pr]
简直酷炫。

* [**travis-ci.org**][travis].
这个就是大众熟知的 Travis 自动化集成工具了，
Travis 对开源项目免费，
十分友好。
而且功能强大，
[和 GitHub 也有很多集成][github-travis]，
用着十分舒服。
（前提是你得写点 UT 什么的）

* 其它：
还有一些 [CodeCov 测试覆盖率][codecov],
[AppVeyor 又一个好用的 CI][appveyor],
[CircleCI 双一个好用的 CI][circle-ci]
等等，等等……


大概这就是给 ForgiveDB 挑好看的标签的旅程了。
这份心情，
就像是给心爱的键盘选好看的键帽一样美好。

[最后欢迎大家给 ForgiveDB 提 Pull Request][forgivedb]~
就算是[像靖哥哥一样只改改文档][doc-only-pr]，
[混个 contributor 也行][contributor]啊~

[jkzing]: http://www.jingkaizhao.com/
[lowdb]: https://github.com/typicode/lowdb
[tinydb]: http://tinydb.readthedocs.io/en/latest/intro.html
[forgive-meme]: /forgive-her-meme
[forgivedb]: https://github.com/hui-z/ForgiveDB
[readme]: /assets/pics/github/forgive.jpg
[github]: /how-i-use-github
[markdown]: /hrbp-and-markdown
[shields.io]: https://shields.io/
[pypi]: https://pypi.python.org/pypi/forgive
[pyup]: https://pyup.io/repos/github/hui-z/ForgiveDB/
[pyup-pr]: https://github.com/hui-z/ForgiveDB/pull/7
[travis]: https://travis-ci.org/hui-z/ForgiveDB
[github-travis]: https://github.com/marketplace/travis-ci
[codecov]: https://codecov.io/github/hui-z/ForgiveDB?branch=master
[appveyor]: https://www.appveyor.com/
[circle-ci]: https://circleci.com/
[doc-only-pr]: https://github.com/hui-z/ForgiveDB/pull/8
[contributor]: https://github.com/hui-z/ForgiveDB/graphs/contributors

