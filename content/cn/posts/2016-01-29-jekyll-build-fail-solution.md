---
title:     "Jekyll build fail的解决办法"
date:      "2016-01-29 23:24:45"
aliases:
  - /jekyll-build-fail-solution
---

我一直觉得笔记本和台式机`jekyll build`出来的结果不一样，
我猜想是Jekyll的版本不一致。
结果后来`gem update`以后，
反而`jekyll build`还失败了…

<!--more-->

## Jekyll build

`jekyll build`的结果不稳定是很难受的，
尤其每次build完以后`git status`看到的一大堆红色文件名。
而其实大部分都是各种HTML tag位置的差别。

我怀疑这有可能是两台机器上Jekyll的版本不同导致的，
于是我就跑了`gem update`以同步到最新版本。

等这个命令跑完以后，我跑`jekyll build`遇到的都是
`jekyll build fail`这样的ruby错误了。


## Solution

搜了一下其实很简单，这是因为机子内同时装了多个版本的jekyll，
而他们又互相冲突所导致的错误。

（我不禁想问`gem update`为什么不会自动卸载旧版本？）

没错，解决方案就是我们跑一条`gem cleanup`卸载旧版本就可以了。
至少这个解决方案对我的问题是起效的。


## Gem sources

另：有的时候gem官方源很慢，可以选择用`gem sources`命令更换淘宝源。
（不过淘宝源未必更新那么频繁）

```
$ gem sources -l
*** CURRENT SOURCES ***

https://rubygems.org/

$ gem sources -r https://rubygems.org/
https://rubygems.org/ removed from sources

$ gem sources -a https://rubygems.org/
https://rubygems.org/ added to sources
```

