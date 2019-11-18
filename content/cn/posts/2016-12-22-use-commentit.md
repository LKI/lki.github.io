---
layout: post
title: disqus不稳定，于是我开始用commentit了
date: '2016-12-22 20:20:07'
aliases:
  - /use-commentit
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
  - author:
      type: full
      displayName: yanhaijing
      url: 'https://github.com/yanhaijing'
      picture: 'https://avatars0.githubusercontent.com/u/3192087?v=3&s=73'
    content: test
    date: 2017-04-08T13:26:14.848Z
  - author:
      type: github
      displayName: xuyunbo
      url: 'https://github.com/xuyunbo'
      picture: 'https://avatars1.githubusercontent.com/u/3280537?v=3&s=73'
    content: NB NB NB
    date: 2017-05-09T03:14:57.894Z
  - author:
      type: full
      displayName: mliumeng
      url: 'https://github.com/mliumeng'
      picture: 'https://avatars3.githubusercontent.com/u/14054737?v=3&s=73'
    content: '&#x8FD9;&#x4E2A;&#x5389;&#x5BB3;'
    date: 2017-05-26T06:36:14.281Z
  - author:
      type: full
      displayName: hifor
      url: 'https://github.com/hifor'
      picture: 'https://avatars2.githubusercontent.com/u/12930071?v=3&s=73'
    content: test
    date: 2017-06-10T03:00:06.695Z
  - author:
      type: full
      displayName: jJayyyyyyy
      url: 'https://github.com/jJayyyyyyy'
      picture: 'https://avatars0.githubusercontent.com/u/8694379?v=4&s=73'
    content: >-
      &#x4F3C;&#x4E4E;&#x5E76;&#x4E0D;&#x80FD;&#x6210;&#x4E3A;contributor...&#x56E0;&#x4E3A;commit
      by
      &#x8FD8;&#x662F;&#x4F60;&#x7684;&#xFF0C;&#x4E0D;&#x8FC7;author&#x53D8;&#x6210;&#x4E86;&#x5403;&#x74DC;&#x7FA4;&#x4F17;&#xFF08;
    date: 2017-07-21T12:40:10.811Z
  - author:
      type: full
      displayName: cgstudios
      url: 'https://github.com/cgstudios'
      picture: 'https://avatars0.githubusercontent.com/u/22955150?v=4&s=73'
    content: dd
    date: 2017-07-28T13:29:29.631Z
  - author:
      type: full
      displayName: wendyltan
      url: 'https://github.com/wendyltan'
      picture: 'https://avatars0.githubusercontent.com/u/17764067?v=4&s=73'
    content: '&#x54C8;&#x54C8;&#x54C8;'
    date: 2017-10-15T13:35:22.005Z
  - author:
      type: full
      displayName: liminany
      url: 'https://github.com/liminany'
      picture: 'https://avatars1.githubusercontent.com/u/4208263?v=4&s=73'
    content: test
    date: 2017-12-14T06:26:42.954Z
  - author:
      type: full
      displayName: liminany
      url: 'https://github.com/liminany'
      picture: 'https://avatars1.githubusercontent.com/u/4208263?v=4&s=73'
    content: >-
      https://liminany.github.io/m/&#xFF0C;&#x6211;&#x7684;&#x8FD9;&#x4E2A;&#x52A0;&#x4E0A;&#x53BB;&#x4E0D;&#x884C;&#xFF0C;&#x62A5; 
      https://github.com/guilro/commentit/issues/9  
      &#x8FD9;&#x4E2A;&#x9519;&#xFF0C;could not commit the comment to github
      (repository or file not found)
      &#xFF0C;&#xFF0C;&#x600E;&#x4E48;&#x56DE;&#x4E8B;&#x5462;&#xFF1F;
    date: 2017-12-14T07:10:34.473Z
  - author:
      type: github
      displayName: ancongcong
      url: 'https://github.com/ancongcong'
      picture: 'https://avatars3.githubusercontent.com/u/3014521?v=4&s=73'
    content: test
    date: 2017-12-26T17:02:17.248Z
  - author:
      type: github
      displayName: mlkey
      url: 'https://github.com/mlkey'
      picture: 'https://avatars0.githubusercontent.com/u/2994534?v=4&s=73'
    content: '666'
    date: 2018-05-01T15:47:42.616Z
  - author:
      type: full
      displayName: jtianling
      url: 'https://github.com/jtianling'
      picture: 'https://avatars0.githubusercontent.com/u/1190254?v=4&s=73'
    content: test
    date: 2018-09-29T07:05:17.018Z

---

挂在GitHub Pages上的静态博客的评论总是个蛋疼的问题，
我以前一直都是用[disqus][disqus]的，
但是它总是处于墙于被墙的边缘…

<!--more-->


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
[built-blog]:           /how-this-blog-was-built
[disqus-template]:      https://github.com/LKI/lki.github.io/blob/b1c59b15a83fe0e0c9c2af55b15e1d3fa107c551/_includes/comments.html
[duoshuo]:              http://duoshuo.com/
[commentit]:            https://commentit.io/getting-started
[commentit-template]:   https://github.com/LKI/lki.github.io/blob/eb8e55e54fafc4effeeed8ed24ddae142829372b/_includes/comments.html
[commentit-config]:     https://commentit.io/settings?master=true&group=true
[contributors]:         https://github.com/LKI/lki.github.io/graphs/contributors

