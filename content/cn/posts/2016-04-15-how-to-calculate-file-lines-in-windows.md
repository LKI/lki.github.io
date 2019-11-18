---
title:     "如何用Windows命令行统计文件行数"
date:      "2016-04-15 22:13:15"
aliases:
  - /how-to-calculate-file-lines-in-windows
---

今天要统计文件行数，可是手边恰好没有Linux环境。

<!--more-->

## Linux 统计代码行数

在 Linux 下这是一件很简单的事情：

```bash
    find . -name "*.py" | wc -l
```

这行语句就可以很简单地统计出当前目录下所有py后缀文件的行数了。


## Windows 统计代码行数

这时我们就不能用cmd而是应当用PowerShell啦。

[Powershell][powershell]是Windows基于.NET开发的一个自动化配置框架。
（其实就是新版命令行）

然后我们可以输入：

```powershell
    dir .\ -Recurse *.py | Get-Content | Measure-Object
```

我们就可以看到输出：

```
Count : 1253
```

表示当前目录下py后缀文件一共有1253行。

[powershell]: https://en.wikipedia.org/wiki/Windows_PowerShell
