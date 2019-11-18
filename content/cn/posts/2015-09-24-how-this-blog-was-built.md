---
layout: post
title: 这篇博客是怎么建成的
date: 2015-09-24T20:26:17.000Z
aliases:
  - /how-this-blog-was-built
comments:
  - author:
      type: twitter
      displayName: NeverReplyBot
      url: 'https://twitter.com/NeverReplyBot'
      picture: >-
        https://abs.twimg.com/sticky/default_profile_images/default_profile_bigger.png
    content: >-
      &quot;&#x4E8E;&#x662F;&#x6211;&#x5C31;&#x53BB;&#x4E07;&#x7F51;&#x4E70;&#x4E86;&#x4E2A;&#x57DF;&#x540D;&#xFF0C;***CNAME***&#x4E00;&#x4E0B;&#x5230;&#x5B66;&#x6821;IP&#x3002;&quot; 
    date: 2017-05-06T16:29:46.108Z

---

其实最开始的时候我是用[LAMP][wiki-LAMP]在学校的IP上搭了一个个人博客，当时这么搭博客有几个很蠢的问题：

<!--more-->

* 晚上11点断网，早上6点才恢复网络，所以这个“个人博客”会断网
* 学校把对外的80端口给封了，而域名访问默认就是80，所以校外访问博客要变成 `http://cloudisdream:8080`这种奇怪的模式
* 由于是自己的电脑做服务器，还得保证一直开着，这样始终不太好

## JAVA / Servlet / Structs + Spring + Hibernate

> 在收了可观的小费以后，旅店老板悄悄地告诉你： 每个大学的软件工程专业都会教JAVA+SSH

其实在LAMP之前，我曾经试过用课程里的Java+Servlet写过一个类微博的（个人？）网站

大概长这样子:
![First site][thats-moon]

一边写我就一边感慨网页设计真是艰难，而且其实这个主页也是模仿当时的网易微博的


## LAMP + WordPress

在前台HTML CSS JS到后台JAVA SQL都写过一遍以后，我开始意识到全栈工程师虽然听起来很美好，但是写起来实在是心太累了

那个时候和ED聊天，刚好聊到[他的博客][edward-mj.com]是用WordPress搭的，于是我就在自己的电脑上搭了一个服务器

虽然文章开头说了这么搭建服务器的缺点，但是其实学校还是给我们提供了一个便利：**固定IP**

于是我就去万网买了个域名，CNAME一下到学校IP。

但是因为实在遭不住一直开机，还要断网，后来还是抛弃掉了这个方式。


## Github Pages + Jekyll

现在的博客就是最简单的[GitHub Pages][github-pages] + [Jekyll][jekyll]

网页放在GitHub上可以享受版本控制这个得天独厚的优势，Jekyll用的是Ruby，简单易用好上手。

从无到有搭建博客基本上就这么几步：

1. 注册Github账号，并创建 account.github.com 这个目录
2. 跑`gem install jekyll`，然后`gem new my-site`
3. 修改`_config.yml`到自己的配置，然后在`_post`文件夹里面新增博客即可


## Comments

博客少了评论总感觉哪里不对，因为是GitHub上的静态页面，基本上解决方案有：用[多说评论][duoshuo]，[Disqus][disqus]，或者是用GitHub issue来定制化评论
（我一开始还以为disqus == disquz）

综合各方面，我采用了Disqus，根据[官方的说明文档][disqus-jekyll]

直接在Page里面插入一段Comment Code就可以了。


## Enhancement

至此，基本主题的博客已全部搭建完毕

但是还有几点不足的地方：

1. 页面最下方的Twitter图标最好要改成Weibo的（但是我还没搞懂怎么画）
2. 要补完About界面
3. 使用Kramdown的GFM render方式感觉还是不够好，尤其是界面上，还是[GitHub Issue的Render方式][github-render]看起来比较舒服

看来以后在写博客的同时，也要对网站持续进行优化才可以呀！

[wiki-LAMP]:     https://en.wikipedia.org/wiki/LAMP_(software_bundle)
[thats-moon]:    /assets/thatsMoonPage.jpg
[edward-mj.com]: http://edward-mj.com/
[github-pages]:  https://pages.github.com/
[jekyll]:        http://jekyllrb.com/
[duoshuo]:       http://duoshuo.com/
[disqus]:        https://disqus.com/
[disqus-jekyll]: https://help.disqus.com/customer/portal/articles/472138-jekyll-installation-instructions
[github-render]: https://github.com/LKI/blogs/issues/3
