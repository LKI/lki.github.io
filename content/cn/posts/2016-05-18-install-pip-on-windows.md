---
title:     "在Windows上安装pip"
date:      "2016-05-18 21:39:29"
aliases:
  - /install-pip-on-windows
---

pip是python的包管理工具，在Linux上安装比较简单，
但是在Windows上安装就稍微麻烦些。

<!--more-->

## 安装Python

首先我们到Python的官网[下载Python][python]。

值得注意的是Python2和Python3非常不同，
里面的差别可能有半个Java和JavaScript的差别之大。
我习惯使用的版本是Python2.7。

下载安装完以后，打开
`我的电脑右键菜单>属性>高级系统设置>环境变量`
设置好Path：

![Python Path][path]

然后我们打开命令提示符，就可以进python的shell啦：

```
> python
Python 2.7.11 on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> exit()
```

## 安装pip

我们使用[get-pip.py][get-pip]一键安装pip，
先把它右键另存为下载到某个地方。

然后我们以管理员身份打开命令提示符，
直接用python运行该文件就可以安装pip了：

```
python get-pip.py
```

Windows上运行pip的方式是：

```
python -m pip

Usage:
  C:\CodeEn\Python27\python.exe -m pip <command> [options]

Commands:
  install                     Install packages.
  download                    Download packages.
  uninstall                   Uninstall packages.
  freeze                      Output installed packages in requirements format.
  list                        List installed packages.
  show                        Show information about installed packages.
  search                      Search PyPI for packages.
  wheel                       Build wheels from your requirements.
  hash                        Compute hashes of package archives.
  completion                  A helper command used for command completion
  help                        Show help for commands.
```

## 安装C++ for Python

Windows上很多Python库都依赖于C++ 9.0，
点击下面链接下载并安装：

[Microsoft Visual C++ Compiler for Python 2.7][vc-python]

最后我们就可以使用`python -m pip install`来安装新的module啦

## 参考

1. [PyPA网站的Python安装指引][pypa]

2. [StackOverflow - How do I install pip on windows][so]

[python]:    https://www.python.org/downloads/
[path]:      /assets/python_path.jpg
[get-pip]:   https://bootstrap.pypa.io/get-pip.py
[pypa]:      https://pip.pypa.io/en/stable/installing/
[vc-python]: https://www.microsoft.com/en-us/download/details.aspx?id=44266
[so]:        http://stackoverflow.com/questions/4750806/how-do-i-install-pip-on-windows
