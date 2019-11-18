---
title:     "VIM中小键盘失灵的解决方案(Putty)"
date:      2015-10-09 15:34:16
aliases:
  - /use-keypad-with-vim-and-putty
---

我目前的开发环境是用[Vagrant][vagrant]起一个虚拟机，然后用[Putty][putty]连上去，用VIM做日常的开发工作。

但某一天更新了一些配置以后，我在VIM里用小键盘输入1的时候，VIM就会在前一行加了一个q字符，让我很是困惑。

后来[谷歌了一下这个问题][vim-wiki-keypad]，得知只要把Putty的Application keypad mode给关了就行了。

<!--more-->


## 奇怪的错误

当刚开始小键盘的输入和预期有差别的时候，其实我是很困惑的。

首先我在Bash里面小键盘一切正常，这说明我键盘没问题，应该是VIM哪里不对。

其次我按的是1，结果出来的是前一行的q，我再按一下2，出来的是前一行的r。
假如键盘没有问题，要自己在VIM里面实现一个这种“功能”，那也要加一行配置：
`inoremap <Num1> <Esc>Oq`

但是这也太奇怪了吧，VIM里面怎么可能把`<Num1>`给替换成`<Esc>Oq`这么奇怪的东西？


## 寻求答案

于是我找到了[VIM wiki上的一篇解答][vim-wiki-keypad]

根据这篇解答，问题是出在Putty上。
Putty会默认启用“Application Keypad Mode”，这个选项被启用以后
所有小键盘上的按键（包括<NumLock>）都会输出一串按键序列：

| 原按键    | 生成序列  | 
|-----------|-----------|
| `<Num1>`  | `<Esc>Oq` |
| `<Num2>`  | `<Esc>Or` |
| `<Num3>`  | `<Esc>Os` |
| `<Num4>`  | `<Esc>Ot` |
| `<Num5>`  | `<Esc>Ou` |
| `<Num6>`  | `<Esc>Ov` |
| `<Num7>`  | `<Esc>Ow` |
| `<Num8>`  | `<Esc>Ox` |
| `<Num9>`  | `<Esc>Oy` |
| `<Num0>`  | `<Esc>Op` |
| `.`       | `<Esc>On` |
| `/`       | `<Esc>OQ` |
| `*`       | `<Esc>OR` |
| `+`       | `<Esc>Ol` |
| `-`       | `<Esc>OS` |
| `<Enter>` | `<Esc>OM` |

居然`<Num1>`真的变成了`<Esc>Oq`！

再去翻[Putty关于Application keypad mode的说明][putty-appkeypad]:

>Application Keypad mode is a way for the server to change the behaviour of the numeric keypad

唔，好吧，是服务器端决定的配置。

所以在Putty下简单的解决方案就是关掉这个模式了：

* 打开Putty配置
* 选中左边的Terminal -> Features
* 在"Disable application keypad mode"处打钩
* 选中左边的Session
* 保存Putty配置

![关闭application keypad mode][app-keypad-mode]


## 更多奇怪的答案

在[VIM wiki页面的讨论板块][vim-wiki-comment]，有人给出了一个看起来很蠢的解决方案：

```
:inoremap <Esc>Oq 1
:inoremap <Esc>Or 2
:inoremap <Esc>Os 3
:inoremap <Esc>Ot 4
:inoremap <Esc>Ou 5
:inoremap <Esc>Ov 6
:inoremap <Esc>Ow 7
:inoremap <Esc>Ox 8
:inoremap <Esc>Oy 9
:inoremap <Esc>Op 0
:inoremap <Esc>On .
:inoremap <Esc>OQ /
:inoremap <Esc>OR *
:inoremap <Esc>Ol +
:inoremap <Esc>OS -
:inoremap <Esc>OM <Enter>
```

刚开始看到这个答案我立刻想到了这张XKCD

![workflow][xkcd-1172]

我认为mapping不应该是一个合适的解决方案，但是下面又有人讲了他自己苦逼的故事：

> After a while struggling with this very problem with vnc viewer 4.1.3 under XP with a Debian lenny vnc4server 4.1.1+X4.3.0-31, this vim remapping is the only solution which work.

好吧，至少他找到了解决方案。

![solution][xkcd-979]


[app-keypad-mode]: /assets/putty_application_keypad_mode.jpg
[putty-appkeypad]: http://the.earth.li/~sgtatham/putty/0.60/htmldoc/Chapter4.html#config-appkeypad
[putty]: http://www.putty.org/
[vagrant]: https://www.vagrantup.com/
[vim-wiki-comment]: http://vim.wikia.com/wiki/PuTTY_numeric_keypad_mappings#Comments
[vim-wiki-keypad]: http://vim.wikia.com/wiki/PuTTY_numeric_keypad_mappings
[xkcd-1172]: http://imgs.xkcd.com/comics/workflow.png
[xkcd-979]: http://imgs.xkcd.com/comics/wisdom_of_the_ancients.png
