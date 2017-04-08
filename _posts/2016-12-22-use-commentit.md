---
layout: post
title: disqus不稳定，于是我开始用commentit了
date: '2016-12-22 20:20:07'
permalink: /use-commentit
comments:
  - author:
      type: full
      displayName: scarqin
      url: 'https://github.com/scarqin'
      picture: 'https://avatars0.githubusercontent.com/u/15225835?v=3&s=73'
    content: '&#xFF01;try'
    date: 2017-03-30T06:58:09.693Z
  - author:
      type: full
      displayName: yanhaijing
      url: 'https://github.com/yanhaijing'
      picture: 'https://avatars0.githubusercontent.com/u/3192087?v=3&s=73'
    content: >-
      https://github.com/guilro/commentit/issues/9

      Error: could not commit the comment to github (repository or file not
      found)

      &#x4F60;&#x9047;&#x5230;&#x8FD9;&#x4E2A;&#x95EE;&#x9898;&#x4E86;&#x5417;&#xFF1F;
    date: 2017-04-08T13:19:48.855Z

---

挂在GitHub Pages上的静态博客的评论总是个蛋疼的问题，
我以前一直都是用[disqus][disqus]的，
但是它总是处于墙于被墙的边缘…

<!--MORE-->


[因为~~自己感觉没那个必要从头搭建博客服务器~~懒，于是我直接采用了GitHub Pages。][built-blog]
但是由于GitHub Pages是静态页面，所以评论系统就成了问题。
于是研究了一番以后我用了[disqus][disqus]的第三方评论。

disqus的便利之处在于构建简单，
我只要去注册一下，加一个[comments.template][disqus-template]就可以自动展开成评论页面了。
但是出于种种原因[disqus][disqus]对墙内用户支持的不好。

而且我又不想用[多说][duoshuo]，那个看起来无比蠢……

直到我最近发现了一款黑科技：[Comm(ent|it)][commentit]。
一句话概括它静态评论的原理是：`所有的评论会变成Git Commit，push到你的Repository里面去`。

雾草！
感觉很爽！

而且其实[它的template配置和disqus的一样简单][commentit-template]。
补充：我们还要在[commentit的配置页面][commentit-config]配一下允许直接提交到master :)

:) 所以是时候在本页面下面评论，
以成为[本博客GitHub项目的Contributor啦~][contributors]

[disqus]:               https://disqus.com/
[built-blog]:           http://www.liriansu.com/how-this-blog-was-built
[disqus-template]:      https://github.com/LKI/lki.github.io/blob/b1c59b15a83fe0e0c9c2af55b15e1d3fa107c551/_includes/comments.html
[duoshuo]:              http://duoshuo.com/
[commentit]:            https://commentit.io/getting-started
[commentit-template]:   https://github.com/LKI/lki.github.io/blob/eb8e55e54fafc4effeeed8ed24ddae142829372b/_includes/comments.html
[commentit-config]:     https://commentit.io/settings?master=true&group=true
[contributors]:         https://github.com/LKI/lki.github.io/graphs/contributors

