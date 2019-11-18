---
title:     "hunter2是什么梗"
date:      "2017-03-26 23:58:26"
aliases:
  - /hunter2-meme
---

简单来说：
这是一个弱密码。

<!--more-->

## hunter2

密码安全是个长盛不衰的话题，
前阵子又有人统计了[2016年最弱的密码][weakest-password]。
每次明文存储密码的大网站数据库泄露，
也都[有人统计弱密码排名][password-rank-on-leak]。

像`123456`、`letmein`、`password`都是典型的弱密码。
`hunter2`也是一个弱密码，
其中的梗[起源于2004年左右IRC上面的一段对话][hunter2]：

```
<Cthon98> 在聊天框里输入你的密码，系统会自动地把它变成星号
<Cthon98> ********* 你看！
<AzureDiamond> hunter2
<AzureDiamond> 我看不到星号
<Cthon98> <AzureDiamond> *******
<Cthon98> 我看到你发的是上面这行
<AzureDiamond> 哇哦，真的？
<Cthon98> 没错
<AzureDiamond> 你用hunter2把我的hunter2给hunter2了
<AzureDiamond> 哈哈，你看这串是不是很有意思
<Cthon98> lol 是啊。所以说每次你输入hunter2，我看到的都是*******
<AzureDiamond> 真是酷炫，我以前都不知道IRC会自动屏蔽密码
<Cthon98> 是的，不管你在哪输如hunter2，别人看到的都是*******
<AzureDiamond> 屌爆啦！
<AzureDiamond> 等等，你怎么知道我密码的？
<Cthon98> 呃，我只是把你的*******给复制了一下，你看到的可能是它的原样hunter2
```

用表情图表示就是这样子：

![hunter2][hunter2-img]

这样的套路在新时代就是这样子的：
~~（今天是马化腾的生日，转发你的密码到五个群，再看看你的头像）~~

![hunter2-god][hunter2-god-img]

[XKCD 936]也是讲密码安全的：

![xkcd 936][xkcd-936-img]

于是某Redditor也发现了，
写教务处网站的那个同学，
[也看XKCD][reddit-password]：

![password][reddit-password-img]

所以总的来说，
`hunter2`就是一个关于弱密码的梗。
希望大伙的密码都很安全，
相关的虚拟财产什么也都很安全 :)

## 其它

在如今，用一个好的密码管理软件是很好的选择。
假如你嫌密码管理软件太麻烦，
那么选一个有数字、大写字母、小写字母、特殊字符的10位以上的密码也是不错的选择。

然而有很多网站不支持特殊字符ORZ
还有网站限制了很短的密码长度…
╮(╯▽╰)╭ 假如网站登录框旁边，
能把他们当初注册的密码条件写上就好了。

[weakest-password]: https://blog.keepersecurity.com/2017/01/13/most-common-passwords-of-2016-research-study/
[password-rank-on-leak]: https://36kr.com/p/5038663.html
[hunter2]: http://bash.org/?244321
[hunter2-img]: /assets/hunter2.jpg
[hunter2-god-img]: /assets/hunter2-god.jpg
[xkcd-936]: https://xkcd.com/936/
[xkcd-936-img]: https://imgs.xkcd.com/comics/password_strength.png
[reddit-password]: https://www.reddit.com/r/xkcd/comments/2f5xps/my_university_has_good_password_instructions/
[reddit-password-img]: http://i.imgur.com/ElRxuGK.png
