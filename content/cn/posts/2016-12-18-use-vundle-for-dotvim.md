---
title:     "用vundle来管理vim插件"
date:      "2016-12-18 02:22:16"
aliases:
  - /use-vundle-for-dotvim
---

今天把vim插件管理器换成了[Vundle][vundle]，
之前我一直用的是[pathogen][pathogen]。

<!--more-->


## Vim配置

其实我是在实习以后才开始用Vim的，
当时Justin直接把[他的vim配置][dotvim-justin]给我clone了一份。
直接用现成的配置大大减缓了Vim的学习曲线，
而且很快就可以上手用起来了。
直到现在，我也觉得上手Vim的正确姿势就是找个大腿的配置。

后来Vim稍微用的多了一些以后，
我开始尝试自己手动改vimrc来改设置。
改代码的基础就是看代码/学习代码，
于是我了解到了[pathogen][pathogen]，
一个快速添加插件的Vim插件...


## pathogen

pathogen的优点就是小巧和直白：

你只需要添加autoload文件夹，
配置pathogen的载入，
就可以自己在预设好的插件目录下任意增删插件了。

然而实际使用中有几个蛋疼之处：

* 为了方便，我一般会用git submodule来添加插件。
git submodule不仅有着屎一样的用法，
它的commit还是固定的，
于是我经常要手动去更新插件版本。
* 因为用了git submodule，删除插件也变得麻烦了。
* [pathogen][pathogen]主要是[Tim Pope][tpope]写的，
而这个项目一年内只有三次更新…
一点也不活跃。

出于灵活度/便携度/活跃度的考虑，
我决定换个包管理器。


## Vundle

于是我就想到了[Vundle][vundle]，
一个看起来很正式的Vim插件管理器。
它的配置其实也比较简单：

本地克隆[Vundle][vundle]包（可用git submodule），
配置vimrc，然后在vimrc内写入插件名。

不过第一次用命令`vim +PluginInstall +qall`加载插件的过程可能比较慢。


## 现在的配置

于是鼓捣了一下，
成功从pathogen换成了vundle。
dotvim地址在[github上][dotvim]。

题外话：
第一次了解到[Vundle][vundle]的时候，
我总感觉这有种浓浓的Emacs包管理山寨风，
于是当时我根本没考虑[Vundle][vundle]…
所以说**技术品味不能充当唯一技术评判标准呀~**

[vundle]:          https://github.com/VundleVim/Vundle.vim
[pathogen]:        https://github.com/tpope/vim-pathogen
[dotvim-justin]:   https://github.com/LKI/dotvim
[tpope]:           https://github.com/tpope
[dotvim]:          https://github.com/LKI/dotvim
