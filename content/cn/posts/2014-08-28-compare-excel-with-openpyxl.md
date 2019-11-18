---
title:     "用Openpyxl做两个Excel文件的比对"
date:      2014-08-28 10:31:08
aliases:
  - /compare-excel-using-openpyxl
---

## 起因

最近老是要做比对Excel报表的工作，于是想写一个Python的小脚本来做这个工作。
关于Python的Excel处理，以前只用过xlrd库，处理的是Office03的.xls文件。
这次写小工具的同时也是学习一下新的东西。

<!--more-->

## 准备工作

由于本次要比对的报表是Office07的.xlsx文件，上网查了一下Python怎么做比较合适。
看了几篇心得以后，敲定用Openpyxl（参考如下链接：）

>[Python处理Excel的四个工具][4toolForPythonExcel]

于是接下来是装Openpyxl，到官网上按照流程装了一发：

>[A Python Library: Openpyxl][Openpyxl]

由于源码是到BitBucket上拖下来的，所以顺便还装了SourceTree。
据说SourceTree还有Git的相关功能，下次可以体验一下。


## 使用Openpyxl

Openpyxl装好以后直接import就能用啦：

```python
from openpyxl import *
```

Openpyxl还提供了一个非常棒的教程~~（有点过于简单~~

>[Openpyxl Tutorial][OpenpyxlTutorial]

Openpyxl还有个弊端就是文档不怎么详细，只能去翻源码。


## 最终代码

可以到我写的PythonScripts里找到我写的版本：

[PythonScripts - ExcelComparer][ExcelComparer]

[4toolForPythonExcel]:http://www.gocalf.com/blog/python-read-write-excel.html
[Openpyxl]:https://pythonhosted.org/openpyxl/
[OpenpyxlTutorial]:https://pythonhosted.org/openpyxl/tutorial.html
[ExcelComparer]:https://github.com/LKI/PythonScripts/tree/master/ExcelComparer
