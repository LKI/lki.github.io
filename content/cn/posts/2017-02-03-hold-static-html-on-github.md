---
layout: post
title: 用GitHub托管静态HTML页面
date: '2017-02-03 21:59:54'
aliases:
  - /hold-static-html-on-github
---

这是一篇入门级的技术文章，
教你怎么在GitHub上托管静态的HTML页面。

<!--more-->


## GitHub项目主页

GitHub有个设定，
就是**每个项目的gh-pages分支可以通过`user-domain/项目名`来访问**。

比如以前我把一些常用的js/css库放到[我的static项目下(LKI/static)][lki-static]，
该项目下`gh-pages`分支的index.html就可以直接通过[lki.github.io/static][html-static]访问。

GitHub的这个设定本意是[让每个项目都有自己的主页来展示][pages]，
不过我们也可以借用这个设定来托管静态HTML页面。


## 托管静态页面

托管页面的大概步骤如下：

1. 拥有自己的GitHub账号
2. 在GitHub上建立一个目录[(Create new repository)][create-repo]
3. 用git创造该项目下建立`gh-pages`分支，提交一个index.html文件

第3步的命令行版本大概如下：

```
$ cd /Users/liriansu/new-repo
$ git init                        # 初始化git目录
$ git checkout -b gh-pages        # 新建gh-pages分支，并切换过去
# 跑完上一条命令后，把你的index.html文件放到new-repo文件夹里
$ git add index.html              # 告诉git说index.html要提交了
$ git commit -m "add index.html"  # 提交index.html
$ git remote add origin https://github.com/<username>/<repository>
$ git push -u origin gh-pages     # 推到GitHub服务器上
```

然后我们就可以在`http://<username>.github.io/<repository>`上看到刚提交上去的index.html了。
最后假如你希望在GitHub上搭建个人博客，
可以参照[我的搭建方案][build-a-blog]


[build-a-blog]:   /how-this-blog-was-built
[lki-static]:     https://github.com/LKI/static
[html-static]:    /static/
[pages]:          https://pages.github.com/
[create-repo]:    https://github.com/new

