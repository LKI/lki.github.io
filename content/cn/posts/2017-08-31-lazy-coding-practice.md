---
title:     "写代码怎么偷懒？多练练"
date:      "2017-08-31 20:25:12"
aliases:
  - /lazy-coding-practice
---

相比于“一门语言”，
“一门程序语言”更多时候是“一门规范”。
（当然，“语言”本身就是“规范”。）

<!--more-->

![standards][xkcd-standards]

[上次讲到了写代码想偷懒的话][thinking]，
**搞明白、想清楚再写**是解决根源的一个办法。
但是凡人（没打错字）的需求始终不是重点，
写程序要偷懒，
最终还是在代码上偷懒的。

## Best Practice

外国程序员很喜欢念叨一个词，
叫`Best Practice`。
比如说`Java`里面`JSON`要怎么处理，
就可以搜`Java JSON Best Practice`；
比如我对数据库一窍不通，
但我就是要学，
可以搜`Database Best Practice`；
比如我是甲方，
我不知道我自己想要什么，
我也可以搜`Requirements Best Practice`。

这种英文单词一般会有一个直译的中文，
叫`最佳实践`，
听起来巨蠢。
但是用来举例子就很好用。

我加入[再惠][zaihui]的时候，
只写过一点`Python`，
代码习惯也是不加`encoding`，
不知道`from __future__`，
写`print`不写括号的，
所有要用到的第三方库都装在全局的`site-packages`下面。
来了以后[我知道了`virtualenv`][virtualenv]。
后来张总玩`Lucene`的时候我给他配了下`Gradle`，
并解释了一下：“这个东西很简单的，跟`virtualenv`是类似的概念。”
张总感慨道：
“其实学一门语言就是从这些工具开始啊，
这样才有一种我上手了的感觉啊！”

还有就像[`Go`语言的`gofmt`命令][gofmt]，
这个命令会强制执行统一的代码风格调整，
不能配置、不能定制化、缩进统一使用Tab。
我十分痛苦，
不过也十分认可这里的思想：
“语言风格就是~~林黛玉~~哈姆雷特，千人千面。
相比于完美的风格，统一的风格更科学。”

`Best Practice`就是实际操作时的指南，
了解、掌握、实践`Best Practice`可以~~少些很多代码~~少走很多弯路，
用精妙的方法解决实际问题。


## 精妙的方法

按照套路，接下来应该讲一段精妙的方法。
不过小弟我没啥精妙的方法，
就只能举自身当反例了。

在写`API`的时候，
经常要处理`URL`，
处理`URL`实际上是字符串拼接。
比如`Python`里面把一个`dict`转换成`query string`格式，
我以前会这么写：

``` python3
params = {'name': 'afu', 'action': 'take a plane'}
query_string = '&'.join(['{}={}'.format(k, v) for k, v in params.items()])  # 'name=afu&action=take a plane'
```

当时自我感觉良好，
觉得`Python`不愧是`Python`啊，
`List Comprehension`真优雅，真好看。
然而这段代码不仅有Bug，
其实`Python`有专门的库`urllib`来处理这类问题，
`urllib`也已经考虑了各种边界情况（比如带非法字符等）：

``` python3
# 举Python3为例
import urllib

params = {'name': 'afu', 'action': 'take a plane'}
query_string = urllib.parse.urlencode(params)  # 'name=afu&action=take+a+plane'
```

后来又学到了`urlencode`函数在`Python2`和`Python3`的位置都不一样，
一般是用[`six`][six]这个库去处理兼容性的。
下面这段代码就不需要额外说明_举Python3为例_了：

``` python
import six

params = {'name': 'afu', 'action': 'take a plane'}
query_string = six.moves.urllib.parse.urlencode(params)  # 'name=afu&action=take+a+plane'
```

虽然有很多种方法都能达到同样的效果，
但软件工程中，
大家往往都定下一个`Best Practice`然后遵守它。
这样不仅能省下写程序的功夫，
也能省下沟通争辩的功夫。
就像[`Zen of Python`][zen]里说的一样：
`There should be one-- and preferably only one --obvious way to do it.`

之前我一直很好奇大部分人在用`Python`写`datetime`类型的时候，
都是用`import datetime`+`datetime.datetime(), datetime.date()`的写法，
我就一直不解，
`from datetime import datetime, date`+`datetime(), date()`这样感觉更好啊？
而且后续的代码更短。

后来读到[`Kenneth Reitz`的`Hitchhiker's Guide to Python`][python-guide]的时候我才明白，
`Explicit is better than implicit`的体现就是显式指定包名，
这样代码表现力就会更强，也更易读。

```
## Very bad

[...]
from modu import *
[...]
x = sqrt(4)  # Is sqrt part of modu? A builtin? Defined above?


## Better

from modu import sqrt
[...]
x = sqrt(4)  # sqrt may be part of modu, if not redefined in between


## Best

import modu
[...]
x = modu.sqrt(4)  # sqrt is visibly part of modu's namespace
```

从学到这一点以后，
我就下定决心再也不用`from datetime import datetime`了。


## 总结

`Best Practice`这种东西，
看起来很美好，
用好了可以大大~~偷懒~~减少工作量。
但它有一个重要特性：
`Best Practice`从来不是试出来的，
而是**思索、学习、择优**得到的。
多加一个`if`，多加一个机器，多招一个人，多加一点班
可能只能解决当下的问题。
平时多学习一个，
才能到了要解决问题的时候，
面临技术、业务、上线时间的多重压力，
优雅地使用`Best Practice`解决问题。

总的来说，
为了~~偷懒~~ ~~少干活~~提高效率，
我们又定下了这么些小目标：

* 多学习一个`Best Practice`
* 学到了就用，能用精妙的方法就不用愚蠢的方法
* 通过思考来学习，而不是完全通过试错反馈机制来学习

毕竟编程风格可不能是[散弹枪编程][random-programming]呀。


[xkcd-standards]: https://imgs.xkcd.com/comics/standards.png
[thinking]: /lazy-coding-thinking
[zaihui]: /my-work
[virtualenv]: http://docs.python-guide.org/en/latest/dev/virtualenvs/
[gofmt]: https://blog.golang.org/go-fmt-your-code
[six]: https://pythonhosted.org/six/
[zen]: https://www.python.org/dev/peps/pep-0020/
[python-guide]: docs.python-guide.org/en/latest/
[random-programming]: https://coolshell.cn/articles/2058.html

