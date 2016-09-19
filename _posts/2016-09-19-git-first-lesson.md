---
layout:    post
title:     "git新手教程"
date:      "2016-09-19 16:04:00"
comments:  true
permalink: /git-first-lesson
---

本文主要介绍版本控制工具Git的基本概念，
以及init，commit，log和reset的几个基本命令。

<!--MORE-->

## 什么是Git

在十多年前，有好多程序员一起开发Linux系统。
这么多人一起写一个软件，他们就需要一个好的软件来
控制代码的版本/回滚代码/并行开发。
最开始他们是用的一个现成的软件叫*BitKeeper*，
但是[后来BitKeeper居然想收费！于是他们就开发出了Git…][git-hist]

没错，Git就是一个由程序员自己写的，
写给程序员自己用的，用来管理写程序的工具。
本文想做的就是把[Git][git-wiki]这个*程序员用的*工具
介绍给不懂写代码，但是要写文档，改文档的同学。

（所以本文的具体栗子是在Windows系统下进行）


## 什么是版本控制

举个栗子：
今天要写毕业论文，我打开了Microsoft Word， 写完了第一章。
但我突然有一个更好的想法，我决定重写第一章。
于是我按下了**撤销**按钮，Word文档**回滚**到了最开始的地方。
我坐了三分钟，我发现其实还是我之前的第一章写的比较好。
于是我按下了**重复**按钮，Word文档又**回滚**到了我写完第一章的时候了。

上面的栗子，其实就是一个典型的*版本控制*场景。
而Git作为版本控制的工具，做的就是文件级别的*版本控制*。

接下来我们直接来试用Git。


## 安装Git

首先我们到[Git的官方网站（英文）][git-down]
去下载最新的windows版本的git：
（当你用浏览器打开这个网站的时候，就应该有下载框弹出来了）

下载地址：https://git-scm.com/download/win

下载完毕以后打开，大部分设定用默认的就行了，
几个关键选项图示如下：

![options][inst-opt]
![commands][inst-cmd]
![line-endings][inst-le]

安装完毕后我们在任意菜单右键，
应该就可以看到“Git Bash Here”的选项。
并且打开以后我们输入`git version`
可以查看到git版本号信息，
这就说明我们安装成功了。

    $ git version
    git version 2.9.0.windows.1
    （具体版本可能会随时间变化，但这并不重要）

## 未完待续

[git-hist]: https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git
[git-down]: https://git-scm.com/download/win
[git-wiki]: https://en.wikipedia.org/wiki/Git
[inst-opt]: /assets/git_first_inst_opt.jpg
[inst-cmd]: /assets/git_first_inst_cmd.jpg
[inst-le]: /assets/git_first_inst_le.jpg
