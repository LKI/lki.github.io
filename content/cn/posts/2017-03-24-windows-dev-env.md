---
title:     "搭建舒适的 Windows 开发环境"
date:      "2017-03-24 02:00:55"
aliases:
  - /windows-dev-env
---

假如你也不介意身处[鄙视链][we-are-the-same]的最底端，
那来交流一下`怎么样搭建Windows的开发环境`吧

<!--more-->


## [鄙视链][we-are-the-same]的最底端：Windows

[鄙视链][we-are-the-same]是程序员日常生活中确实的一部分，
比如拿经典的编程语言来说，
有种说法是：

> C 语言工程师鄙视 C++ 工程师，
> C++ 工程师鄙视 Java 和 C# 工程师，
> Java 工程师和 C# 工程师则互相鄙视。
> 写静态语言的工程师鄙视写动态语言的工程师。
> 用 Python 3 的工程师鄙视还在用 Python 2 的工程师，
> 用 Python 2 的工程师鄙视遇到 UnicodeEncodeError 的工程师。
>
> 所有的工程师都鄙视 PHP 工程师。

而在用的操作系统方面，
[鄙视链][we-are-the-same]的说法基本是这样的：

> 用 Mac OS X 的工程师鄙视用 Linux 的工程师，
> 用 Linux 的工程师鄙视用 Windows 的工程师。

虽然是这么说，
但我还是很喜欢 Windows 的开发环境，
主要原因是：**可以玩游戏**…
虽然目前我已经几乎不玩了，
但是这个**可以玩游戏**的无限可能性深深地吸引着我...

o(〃'▽'〃)o
所以我们要通过一系列步骤，
搭建一个最舒服的 Windows 开发环境！~~和游戏环境~~


## 必备软件

有几个软件我认为是 Windows 开发环境中必不可少的。

### [Chocolatey][chocolatey]

[Chocolatey][chocolatey] 是 Windows 上的命令行包管理软件，
不是官方的，
但是非常好用。

以管理员身份打开 `cmd.exe` 后运行一行命令即可装成功：

```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

装好以后一行命令就可以装上常用软件，
以及把 Path 环境变量配好：

```
choco install -y 7zip everything git jdk8 nodejs npm python2 putty vagrant virtualbox vim wox
```

唯一缺点是安装过程都是采用默认值静默安装的，
假如有些软件要取消掉右键菜单，
或者放在特定文件夹内则需要自己搞一下。


### [Wox][wox]

就是上一条 `choco` 命令最后要装的那个 [wox][wox] ，
一个快速启动应用的工具。

假如你知道 Mac OS 系统上的 `Spotlight` 或者 `Alfred` 的话，
[wox][wox] 就是它们在 Windows 上的版本。

比如我在任何界面，
敲下 `Alt + Space` 的快捷键以后，
就弹出了白色的输入框。
我输入程序名后按下回车，
就会自动打开该程序。
[wox][wox]支持通配符，
支持搜索，
支持系统操作（比如锁屏、重启），
加上 [everything][everything] 以后支持搜索文件。

![wox-sample][wox-sample]


### [Git Bash][git-scm]

此处讲的不是 Git ，而是特指 [Git Bash][git-scm]。
[Git Bash][git-scm] 是装 Git 附带装的基于 [mingw (MINimal Gnu for Windows)][mingw] 的一个终端软件。
自带 bash / ls / find / grep / wc 等 Linux 命令行工具，
支持 .profile 自定义环境变量，
支持 git 文件状态显示。
有了这个以后我基本没用 cmd 或者 powershell 了。


## 我的偏好

前文的三个软件我是强烈推荐使用的。
下面还有一些带有一定的，
或者是强烈的个人品味的软件。

* `VirtualBox + Vagrant + Putty`：平常开发的时候，我会用 `vagrant init ubuntu/trusty64 && vagrant up` 来起一个 Ubuntu 虚拟机，然后用 Putty 连上去，把这个虚拟机当一个完全体 Server 来用。[VirtualBox][virtualbox] 是虚拟机载体，类似于 VMware ，但是版权协议更宽松。[Vagrant][vagrant] 是虚拟机管理软件，提供主机与虚拟机的数据通讯，还有一些自动化的活。[Putty][putty] 是老牌远程终端软件。
* [`JetBrains全家桶，包括IntelliJ IDEA, PyCharm, Rider EAP, ReSharper`][jetbrains]：JetBrains 毕竟是做 IDE 的商业公司，还是比_一些_开源 IDE 要好的，比如他们家的 IDE 基本上不会出现[10年都没解决的Issue][backslash-r]...
* `网易云音乐 + 有道词典 + 有道云笔记`：呃，这个不知道怎么介绍，就大概是字面意义上的需要这些东西吧。咖啡和音乐是程序员的好伙伴，我不怎么喝咖啡，我就只有音乐了。
* [`everything`][everything]：巨快巨好用的 Windows 全局搜索软件，效率可比 Linux 上的 `locate` 命令。
* [`Vim, Windows 上的是 GVim`：编辑器之神][editor-war]。


## 其它技巧

* [左耳朵耗子的建议： 作环保的程序员，从不用百度开始][no-baidu]
* 除了 `Alt + F4`，Windows上的 `Win + E`, `Win + R`, `Win + D`, `Win + L`, `Win + Tab` 也很有用。
* 而可以用 `终端中左键选中` 来复制，`Shift + Insert` 来粘贴。
* Windows 中与 `ln` 类似的命令是 `mklink <dest> <source>`。假如是目录则要加参数 `mklink /d <dest> <source>`
* 假如你用 Vim，把 `<Caps Lock> 大写锁定` 键改成 `<Ctrl>` 键吧。
* 本文中用到的一些配置，也可以在[我 GitHub 的配置项目][myconf]中找到。

[backslash-r]: https://bugs.eclipse.org/bugs/show_bug.cgi?id=76936
[chocolatey]: https://chocolatey.org/
[editor-war]: https://en.wikipedia.org/wiki/Editor_war
[everything]: https://www.voidtools.com/
[git-scm]: https://git-scm.com/downloads
[jetbrains]: https://www.jetbrains.com/
[mingw]: http://www.mingw.org/
[myconf]: https://github.com/LKI/myconf
[no-baidu]: https://coolshell.cn/articles/9308.html
[putty]: http://www.putty.org/
[vagrant]: https://www.vagrantup.com/
[virtualbox]: https://www.virtualbox.org/wiki/VirtualBox
[we-are-the-same]: https://www.zhihu.com/question/24270600
[wox-sample]: /assets/windows_wox.jpg
[wox]: http://www.getwox.com/
