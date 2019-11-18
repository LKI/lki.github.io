---
layout: post
title: 最精简的程序语言：Iota
date: '2017-01-24 13:07:50'
aliases:
  - /iota-language
comments:
  - author:
      type: github
      displayName: LKI
      url: 'https://github.com/LKI'
      picture: 'https://avatars0.githubusercontent.com/u/3286092?v=4&s=73'
    content: >-
      &#x6211;&#x53D1;&#x73B0;&#x8FD9;&#x91CC;&#x7684;&#x8BBA;&#x8BC1;&#x5C11;&#x4E86;&#x5173;&#x952E;&#x7684;&#x4E00;&#x6B65;&#xFF1A;

      &grave;SKI&grave;&#x7B97;&#x5B50;&#x7684;&#x56FE;&#x7075;&#x5B8C;&#x5907;&#x6027;&#x3002;


      &#x611F;&#x89C9;&#x5C31;&#x662F;&#x4E00;&#x5F00;&#x59CB;&#x8BB2;&#x4E9B;&#x7B80;&#x5355;&#x7684;&#xFF0C;&#x7136;&#x540E;&#x5C31;&ldquo;&#x6613;&#x8BC1;&rdquo;&#xFF0C;PIA&#x5730;&#x4E22;&#x4E2A;&#x7ED3;&#x679C;&#x51FA;&#x6765;&#x3002;

      &#x8FD8;&#x662F;&#x4E0D;&#x591F;&#x76F4;&#x767D;&#x5440;&#x3002;
    date: 2017-09-16T12:36:26.588Z

---

这门语言，只有两个保留字[(reserved keyword)][wiki-reserved-keyword]

<!--more-->


## 各种语言的reserved keyword

今天逛SO的时候发现了这样一个问题：
[Reserved keywords count by programming language?][so-reserved-keyword]

各语言的保留字数目按从大到小的量大概如下：

| ANSI COBOL 85 | 357   |
| JavaScript    | 180   |
| C#            | 102   |
| Java          | 50    |
| Python 3.x    | 33    |
| C             | 32    |
| Go            | 25    |
| Brainfuck     | 8     |
| iota          | **2** |

嗯，Python的保留字果然是少，
怪不得[有个笑话是说Python其实是“可执行的伪代码”][executable-pseudocode]

> python is executable pseudocode, while perl is executable line noise.

不过等等，这个iota是什么语言？
居然只要两个保留字就可以实现图灵完备了？


## Iota 程序语言

虽然这里我们说Iota是程序语言，
但其实真要用Iota写可执行的脚本程序还是没那么简单的。
这里的“程序语言”更大意义上是计算机科学里的图灵完备的解决可计算问题的概念，
那么首先我们来看Iota的设计概念：

[Iota on wikipedia][iota]

呃，上面那个页面其实是希腊字母里的Iota `ι`
下面这才是iota程序语言：

[Iota and Jot][iota-jot]

wiki上很好地介绍了iota，大概意思（也就是我消化过以后）：
相对于知名的[lambda calculus][lambda]和[SKI combinator calculus][ski]来说，
Iota和Jot是非常精简的[Formal System][formal-system]，
它们的设计初衷就是用尽量少的算子来完成图灵完备的语言。
简单来说iota只有两个保留字，一个是 `*`, 一个是`i`，
`*`会结合后面两个iota表达式，而`i`会接受表达式`x`，返回`xSK`。

看完上面一大段可能已经有点晕乎了，
那么换个角度，我们想象一下iota是怎么被创造出来的吧。

一群人聚在一起，
当时已经有了图灵理论，
有了lambda算子，
有了functional programming，
于是有人提了个问题：
最精简的图灵完备的语言是什么？
于是[Chris Barker][chris]站在一系列已有理论的基础上，
发明了[iota][iota-jot]这门语言。


## SKI 算子

[SKI][ski]就是iota发明路上一个很重要的巨人肩膀。
SKI一共定义了三个算子，分别是`S`, `K`, `I`
:) 这名字听起来十分简单粗暴，我很喜欢。
规则如下：

* SKI以带括号表达式的形式呈现，可以把`xy = z`简单理解为`函数x接受参数y返回值z`
* `I`接受一个参数，并返回它，即有`Ix = x`
* `K`接受两个参数，并返回第一个参数，即有`Kxy = x`
* `S`接受三个参数，返回一三参数对二三参数的操作结果，即有`Sxyz = xz(yz)`

根据以上*玄妙*的定义，神奇的事情发生了 :)
**`SKI`实际上只需要`S`和`K`算子，`I`算子可以用`SKK`表示** :

```
  SKKx
= Kx(Kx)      # 根据Sxyz = xz(yz)
= x           # 根据Kxy  = x
```

而通过SKI，我们可以做很多的事情：

* 递归
* 取反
* 布尔逻辑

以上例子可以[去维基看原文: SKI combinator calculus][ski]


## 回到iota

在SKI之后，[Chris Barker][chris]提出了iota算子，
有 `ix = xSK`

所以可以推出：

```
  ii
= iSK
= SSKK
= SK(KK)
= SKK <=> I

  i(iI)
= i(ISK)
= i(SK)
= SKSK
= KK(SK)
= K

  iK
= KSK
= S
```

:) 瞧，这就是逻辑的魅力。
我们通过定义一系列很小的基石，
就能处理整个大厦。

总而言之，iota在SKI的基础上定义了一个关键的算子，
再加上`*`字符做到程序化地表示，
从而实现了最精简的程序语言这一目标。

[wiki-reserved-keyword]: https://en.wikipedia.org/wiki/Reserved_word
[so-reserved-keyword]: https://stackoverflow.com/questions/4980766/reserved-keywords-count-by-programming-language
[executable-pseudocode]: https://news.ycombinator.com/item?id=8241308
[iota]: https://en.wikipedia.org/wiki/Iota
[iota-jot]: https://en.wikipedia.org/wiki/Iota_and_Jot
[formal-system]: https://en.wikipedia.org/wiki/Formal_system
[lambda]: https://en.wikipedia.org/wiki/Lambda_calculus
[ski]: https://en.wikipedia.org/wiki/SKI_combinator_calculus
[chris]: https://en.wikipedia.org/wiki/Chris_Barker_(linguist)
