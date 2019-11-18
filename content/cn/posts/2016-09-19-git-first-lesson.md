---
title:     "git新手教程"
date:      "2016-09-19 16:04:00"
aliases:
  - /git-first-lesson
---

这是一篇针对技术小白们的Git科普文章。
本文主要介绍版本控制工具Git的基本概念，
以及init,status,add,commit,reset,log几个基本命令。

<!--more-->

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

安装选项：
![options][inst-opt]

安装命令：
![commands][inst-cmd]

换行符操作：
![line-endings][inst-le]

安装完毕后我们在任意菜单右键，
应该就可以看到“Git Bash Here”的选项。
并且打开以后我们输入`git version`
可以查看到git版本号信息，
这就说明我们安装成功了。

    $ git version
    git version 2.9.0.windows.1
    （具体版本可能会随时间变化，但这并不重要）

## 新手上路

### 打开Git Bash

git是一个命令行工具。
（虽然也有图形界面，但那个太蠢了，
我们还是学习更好用的敲命令吧）

首先我们打开一个文件夹，
比如我打开的是D:\git-first-lesson\XML这个文件夹，
然后`右键菜单 -> Git Bash Here`，
就打开了一个这样的Git Bash：

![hint][git-version]

再顺便说一下几个基本的命令：

* `ls`: list的简写，可以**查看当前文件夹下有哪些文件（夹）**
* `cd`: ChangeDirectory，可以**更换目录**。`cd ..`就是回到上一层目录


### Git目录

**想了解一个目录的状态，就使用`git status`命令**。
我们可以试着跑一下这个命令，但是Git会报这样的错误：

    $ git status
    fatal: Not a git repository (or any of the parent directories): .git

这个错误的字面意思是“错误：你并没有把当前目录（或者任何父目录纳入git版本控制）”。

所以**为了将一个文件夹纳入版本控制，我们要使用`git init`命令**:

    $ git init
    Initialized empty Git repository in D:/git-first-lesson/XML/.git/

提示信息表示git已经初始化完成。
这个过程实际上是git在**当前目录**新建了一个**.git**文件夹：

![dotgit][dot_git]

然后我们再跑`git status`就可以查看到当前目录状态了：

![git-st][git-status]


### 控制文件

在我们初始化完git以后，git默认是把所有文件帮我们找出来的。
但是假如我们并不希望修改.wmv音频文件，.bak备份文件，Data数据文件夹怎么办？
或者假如我们只想版本控制.xml文件该怎么做呢？

git在这里给我们留了一个控制文件，叫**.gitignore**文件。
我们可以`右键 -> 新建文本文件 -> 重命名为.gitignore`或者直接在git-bash里面跑`touch .gitignore`:

![touch][touch]

假如我们想无视wmv文件，bak文件和Data文件夹，我们修改.gitignore内容为：

    *.wmv
    *.bak
    Data\

假如我们只想控制xml文件，我们可以修改为：

    *
    !*/
    !.gitignore
    !*.xml

然后我们可以再跑一次`git status`查看文件夹状态：
（在本例中我的.gitignore只控制了xml文件）

![ignore][git-ignore]


### 设置/查看断点

Git最激动人心的地方到了：
有了前面的准备工作，
我们现在已经可以设置断点，
并且再未来随时回滚到任意断点了！

我们直接看看怎么设置断点（Commit）：

* 使用`git add .`来记录当前目录的改动。
* 使用`git commit -m <commit_message>`来设置断点。

比如我们输入`git add .`和`git commit -m "My First Commit"`：

![commit][git-commit]

好了！断点设置成功！接下来我们可以查看我们设置的断点：

**我们可以使用`git log`来查看断点，或者是`git log --oneline`来查看断点的简略信息。**

比如这样子：

![log][git-log]

### 查看修改内容与回滚

到目前为止，我们所做的操作都不会修改当前文件夹。
我们只是将*整个文件夹当前的状态*纳入了版本控制。

接下来我们要做的就是改动文件了。
比如我们稍微改动了`Struture\recurse.xml`这个文件。

**使用`git diff`可以查看当前文本和上一版本的区别。**

![diff][git-diff]

**使用`git reset --hard HEAD`可以回到上一个断点。**

![reset][git-reset]


## 总结

在本篇新手教程中，我们稍微介绍了版本控制和Git。
在安装完Git以后，我们接触到了以下命令：

| 命令                              | 说明                                       |
|-----------------------------------|--------------------------------------------|
| `git version`                     | 显示Git版本                                |
| `ls`                              | 列出当前文件夹内文件                       |
| `cd data`                         | 更改目录（进入data目录）                   |
| `cd ..`                           | 回到上一层目录                             |
| `git status`                      | 查看Git状态                                |
| `git init`                        | 初始化（使当前文件夹纳入版本控制）         |
| `touch .gitignore`                | 新建.gitignore文件                         |
| `git add .`                       | 使所有未被ignore的文件加入版本控制         |
| `git commit -m "My first commit"` | 设置断点（准确的说是生成一个提交）(commit) |
| `git log`                         | 查看历史                                   |
| `git log --oneline`               | 查看简单历史                               |
| `git diff`                        | 查看当前文件夹状态与最近断点的区别         |
| `git reset --hard HEAD`           | 回滚至上一断点                             |

在之后的教程中，我们会更加深入地接触Git。

（完）

[git-hist]: https://git-scm.com/book/en/v2/Getting-Started-A-Short-History-of-Git
[git-down]: https://git-scm.com/download/win
[git-wiki]: https://en.wikipedia.org/wiki/Git
[inst-opt]: /assets/git_first_lesson/inst_opt.jpg
[inst-cmd]: /assets/git_first_lesson/inst_cmd.jpg
[inst-le]: /assets/git_first_lesson/inst_le.jpg
[git-version]: /assets/git_first_lesson/git_version.jpg
[dot_git]: /assets/git_first_lesson/dot_git.jpg
[git-status]: /assets/git_first_lesson/git_status.jpg
[touch]: /assets/git_first_lesson/touch.jpg
[git-ignore]: /assets/git_first_lesson/git_ignore.jpg
[git-commit]: /assets/git_first_lesson/git_commit.jpg
[git-log]: /assets/git_first_lesson/git_log.jpg
[git-diff]: /assets/git_first_lesson/git_diff.jpg
[git-reset]: /assets/git_first_lesson/git_reset.jpg
