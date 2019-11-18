---
title: "搭建一个不需要自己开服务器的纯静态博客"
date: 2019-11-19T01:00:07+08:00
aliases:
  - /build-a-staic-blog
---

又名：我是如何从 jekyll 切到 hugo 的。

<!--more-->

本文会包括以下内容：

- 背景
- 博客搭建
- 使用感受
- 挖坑


## 背景

前几个月一个老哥给我发邮件：
“commentit 已经凉了啊，记得换掉！”
我才意识到这个静态评论系统已经到了项目终结期。
连 [GitHub Repo][commentit] 都 archive 了。
然后我又意识到：
*已经有一阵没有翻修我的主页了。*

这可不行，
**生命在于折腾**。

于是趁着最近换了新的编码环境，
我重新整了一下我的博客。
俗话说，一图胜千言，
先放张翻修过的博客图：

![blog-preview][blog-preview]



## 博客搭建

> 这一章节讲的是枯燥的步骤，
> 下一章节才讲充满偏见的个人感受 XD

不想自己维护服务器的话，
托管在 GitHub Pages 上是个很好的选择。
四年前我用 jekyll 搭博客的时候也写过一篇：
[《这篇博客是怎么建成的》][lki-build-jekyll]。
大体上，搭建一个功能完备的静态博客分为这几个步骤：

1. 找一个静态内容框架
2. 装一个静态评论系统
3. 配配件：主题、域名等

### 搞框架

[hugo][hugo] 的安装非常容易，
直接用命令行或者[去官网下载][hugo-install]就行了：

```
brew install hugo
```

然后[按照官方的教程][hugo-quickstart]，
一键创建目录 + 默认主题启动就行了：

```
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
echo 'theme = "ananke"' >> config.toml
hugo server -D
```

其它高阶玩法读文档就是了。
至此，第一步，找框架算是做完了。

### 搞评论

[utterances][utterances] 也是一个利用 GitHub Issues 来做评论的工具，
它利用 [Primer][primer] 达成的 GitHub 还原度非常高。

安装也非常简单，
找个模板页把它的配置写上就行了：

```
<script src="https://utteranc.es/client.js"
        repo="[ENTER REPO HERE]"
        issue-term="pathname"
        theme="github-light"
        crossorigin="anonymous"
        async>
</script>
```

对应的效果如下：

![utterances-preview][utterances-preview]

### 其它配件

我用的主题是 [joway/hugo-theme-yinyang][yinyang]，
整体的简约风格让我很喜欢。

字体的话，由于是个人博客，我就没用 FiraCode 这种严谨的字体了，
英文字体我用的是 [ipython/xkcd-font][xkcd-font],
中文字体我还在寻找一个可爱的手写体。

![xkcd-303][xkcd-303]

域名的话，默认会开启 lki.github.io 这样的域名，
需要用自定义的域名可参考官方文档：[github-custom-domain][github-custom-domain]
设置里记得开一下 HTTPS:

![github-pages][github-pages]

要统计访问人数的话，可以用[静态计数器不蒜子][busuanzi]做到：

![blog-header][blog-header]



## 使用感受

我之前的博客系统也是用的 GitHub Pages，
工具链是用的 jekyll + commentit。
整体有这么几个感受：

- 用 GitHub Pages 相比于自建博客而言：
  - 爽：**不需要维护**
    平常在公司做的后端已经够多了，并不想花时间研究自己博客的 502 (x
  - 爽：便宜
    呃，拥抱开源，拥抱开源。
  - 烦：访问速度不够快
    不过这个是 GitHub 的原因，烦也没用。
  - 烦：**受限制**
    比如评论功能，要是自建博客的话实现起来很轻松。
- 用 hugo 相比于 jekyll 而言：
  - 爽：有新鲜感
    有一说一，确实。
  - 爽：**hugo 是 go 写的**
    之前为了 jekyll, 还得在电脑上冗余一套 ruby 的环境，而 go 的环境天然就有。
  - 爽：默认值选的很恰当，不需要过分定制
    不论是 configuration 还是 archetypes, hugo 给我的感受更好，而且 [hardLineBreak][blackfriday-hlb] 这个选项真的好用。
  - 烦：GitHub 只支持自动构建 jekyll
    加个 git pre-push hook 其实就可以解决掉这点，不是特别大的问题。
- 用 utterances 相比 commentit 而言：
  - 爽：**默认样式更好**
    之前 commentit 的样式是我手写的，作为 css 苦手无数次倒在了 `inline-block` 上…
  - 爽：**用 issue 同步评论的方式才是正确的**
    commentit 的哲学是通过 git push 来挂载评论，但是经过实践以后，其实还是用 GitHub Issues 来更王道。

另外值得一提的是，
在考虑从 jekyll 迁出时，
我也认真考虑过 hexo。
不过最终是因为 hugo 看起来更迷人，
同时也为了坚持当时放弃了 hexo,
选了 jekyll 的不必要的倔强(x

![star-history][star-history]

> 附 star 增长趋势对比

还有一个开心的小的点，
就是这个主题对微信公众号的排版支持的比起以前好多啦 :)



### 挖坑

目前的博客改造算是告一段落了，
接下来肯定还是回归到认真工作、认真记录生活的节奏中。

而对于博客本身，
其实还是有不少可以做的坑：

- 用 [Primer][primer] 统一正文评论样式。
- 找个好玩的中文手写字体。（其实这条跟上面那条会冲突）
- 像 TravisCI 一样提供切换字体的选项。（除了 cooooool 以外并没什么用）
- 把友链功能给加上，认真给大家介绍一下我的好友们的实力
- 找个办法，把以前 commentit 的评论优雅地展示出来

要列的话，
能想到要填的坑是一个又一个。
毕竟就像鲁迅常说的那句话一样：
“个人博客是值得认真搞一搞的，
毕竟**生命在于折腾**嘛。”


（完）


[commentit]: https://github.com/jillro/commentit
[lki-build-jekyll]: /how-this-blog-was-built
[hugo]: https://gohugo.io/
[hugo-install]: https://gohugo.io/getting-started/installing
[hugo-quickstart]: https://gohugo.io/getting-started/quick-start/
[utterances]: https://utteranc.es/
[primer]: https://primer.style/
[utterances-preview]: /assets/blog-hugo/utterances.png
[yinyang]: https://github.com/joway/hugo-theme-yinyang
[blog-preview]: /assets/blog-hugo/preview.png
[xkcd-font]: https://github.com/ipython/xkcd-font
[xkcd-303]: https://imgs.xkcd.com/comics/compiling.png
[github-custom-domain]: https://help.github.com/en/github/working-with-github-pages/about-custom-domains-and-github-pages
[github-pages]: /assets/blog-hugo/github-pages.png
[busuanzi]: http://busuanzi.ibruce.info/
[blog-header]: /assets/blog-hugo/header.png
[blackfriday-hlb]: https://gohugo.io/getting-started/configuration/#blackfriday-extensions
[star-history]: /assets/blog-hugo/star_history.png
