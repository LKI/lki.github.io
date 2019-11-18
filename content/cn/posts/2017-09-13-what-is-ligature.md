---
title:     "什么是连字 (ligature)"
date:      "2017-09-13 22:45:39"
aliases:
  - /what-is-ligature
---

或者叫“为什么PDF里拷出来的有些字会消失”，
“为什么有些字体里fi可以连在一起”，
“Fira Code是怎么做到连体符号的”

<!--more-->

## ligature

ligature，维基百科中文页是叫“合字”，其实概念意义上更接近“连字”。
正如字面意义上，连字就是连在一起的字，比如中文的连字是这样的：

> 俗话说，见字如见人。
>
> 有的专家根据特总的签名，
> 分析说他的狂放就如同他那一横一样不羁……

![trump-chinese-ligature][trump-chinese-ligature]

在拉丁语系中，很多时候会用到连字这一特性。
[比如说德语的字母 `ß` 最开始其实是 `ss`][wiki]，
[拉丁字母中的 `W` 最开始的时候是 `VV`, 两个 `V`...][wiki]，
非常神奇。
而我们熟悉的音标里的 `æ` 这个字母，
看起来很像连字，但其实不是连字，
`æ` 是古英语等一系列语系里真实用到的字母。


## fi与印刷体

在活字印刷盛行的时候，
人们都是用字模来印文章的。
一篇文章，
假如要用不同的字体，
那就要选用对应的不同的字模。

![fi][fi]

有些字体里面当 字母`f` 和 字母`i` 连在一起的时候，
`f` 的一横会跟 `i` 的一点撞上，导致不好排版。
所以为了方便、美观，有些字体直接会有 `fi` 连字的字模。
这里不论是印刷字体的连字，还是上面手写字体的连字，
都是一样的概念，都叫 `ligature`。


## 电脑字体里的 ligature

虽然说电脑字体不会有印刷字体所有的物理限制，
但有些字体的 `fi` 还依然保留了 `ligature` 的这一特性。
假如你在你的电脑字体配置页面找一找，
是可以找到相关的属性的。

基于电脑也能支持连字这个设定，
于是聪明的人就想到了可以用它来搞事！
比如有一款字体叫 [Fira Code][fira-code]。

[Fira Code][fira-code] 宣称自己是最适合程序员的编程语言，
因为它对各种数学符号都极度友好（细节请点开下图）

![fira-code-demo][fira-code-demo]

当然前提是编辑器也要能支持 ligature,
比如像 JetBrains系IDE:

![jetbrains-ligature][jetbrains-ligature]


果然正如古代智慧说的一样：

> 苟日新，日日新，又日新

还是要多学习一个呀。


[trump-chinese-ligature]: /assets/pics/trump_chinese_ligature.jpg
[wiki]: https://en.wikipedia.org/wiki/Typographic_ligature
[fi]: /assets/pics/fi.png
[fira-code]: https://github.com/tonsky/FiraCode
[fira-code-demo]: https://raw.githubusercontent.com/tonsky/FiraCode/master/showcases/all_ligatures.png
[jetbrains-ligature]: /assets/pics/jetbrains_ligature.png

