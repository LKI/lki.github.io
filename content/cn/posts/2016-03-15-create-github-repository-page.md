---
title:     "创建GitHub项目主页"
date:      "2016-03-15 21:19:53"
aliases:
  - /create-github-repository-page
---

最近终于偶然了解了怎么给GitHub项目建主页。

<!--more-->


## GitHub Pages

GitHub Pages是一个让用户很方便托管项目网页在GitHub的服务。
比如[我这个博客就是GitHub Pages建成的][build-blog]。

但是这样只能托管一个名为
[GitHub用户名 + ".github.com"的项目(lki.github.io)][lki-github]

假如我还有一个项目也想用域名访问怎么办呢？

于是我机智的我[用`git submodule`来解决了这个问题][git-submodule]。


## Git Submodule

`git submodule`其实是一个很蠢的解决方案：

1. 为了保证最新的内容，父项目要随着子项目更新而更新。

2. 这个做法其实是hack了jekyll build，感觉不是特别靠谱。

3. [remove a git submodule][remove-submodule]实在是太痛苦了！
所以没有必要就不要加git submodule啦。


## 更好的解决方案

前几天在逛[羡辙学姐][zhangwenli]的GitHub的时候发现了[这么一条Issue][issue3]

里面这么说道：

> 主页用 CNAME 指向 zhangwenli.com 后，ovilia.github.io 将跳转到 zhangwenli.com
其他项目 xxx 的 gh-pages 分支将会自动对应到 ovilia.github.io/xxx

喔！原来GitHub会默认地把some-repo项目的“gh-pages”分支映射到some-one.github.com/some-repo下面去。

所以我们就可以用新建分支把[菜谱][git-mymenu]映射到[/mymenu][mymenu]了。


## 总结

1. GitHub项目可以建一个`gh-pages`分支来映射到github.com下面的github.com/repository-name.

2. 多看多学多试.

3. 假如不是绝妙的hack就要追求best practice.

[build-blog]: /how-this-blog-was-built
[lki-github]: https://github.com/LKI/lki.github.io
[git-submodule]: https://github.com/LKI/lki.github.io/commit/86d73353e4b8f93ea7e759fb0d2f47b5d9ad8904
[remove-submodule]: http://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule
[zhangwenli]: http://zhangwenli.com/
[issue3]: https://github.com/Ovilia/cv/issues/3
[git-mymenu]: https://github.com/LKI/mymenu
[mymenu]: /mymenu
