---
layout: post
title: 我的一点强迫症
date: '2018-05-07 22:07:44'
aliases:
  - /my-coding-ocd
comments:
  - author:
      type: github
      displayName: YemingLakeForest
      url: 'https://github.com/YemingLakeForest'
      picture: 'https://avatars2.githubusercontent.com/u/6832909?v=4&s=73'
    content: '&#x8FD8;&#x662F;&#x5FCD;&#x4E0D;&#x4F4F;&#x87C6;&#x4E86;&#x5440;'
    date: 2019-06-26T13:31:04.408Z

---

每个程序员都有他自己的强迫症。
一旦被戳中了，
就不禁心里暗暗会喊一声“舒服”。

<!--more-->


# 正确使用空格

> 有研究显示，
> 打字的时候不喜欢在中文和英文之间加空格的人，
> 感情路都走得很辛苦，
> 有七成的比例会在 34 岁的时候跟自己不爱的人结婚，
> 而其余的三成最后只能把遗产留给自己的猫。
> 毕竟爱情跟书写都需要适时地留白。
>
> - [vinta/pangu.js][pangu]

现代社会的程序员总是要接触英文，
而很多时候我们会在中文中夹杂英文。

这种时候假如见到不留白的字我就会很难受：

```
错误：我今天带GF去吃了KFC的嫩牛五方。
正确：我今天带 GF 去吃了 KFC 的嫩牛五方。
```


# 正确使用全半角符号

当时在微信公众号的文档 JSON 样例数据里，
发现了全角双引号的我，
就像初中时回宿舍路上，
在马路中央见到了一直死老鼠的阿锋一样惊恐。

中文使用全角符号，
英文使用半角符号并留白，
连接处使用全角符号。

```
错误：你们搞信息竞赛(OI)的有句话叫"code is cheap，show me your boyfriend。"
正确：你们搞信息竞赛（OI）的有句话叫“code is cheap, show me your boyfriend.”
```


# 文本文件以换行符结尾

`No newline at end of file` 这句话就像是“你房间没锁门”一样令人惊悚。

不过专业地说，
[在 POSIX 标准里行的定义][posix-line]是：

> 3.206 Line
> A sequence of zero or more non-\<newline\> characters plus a terminating \<newline\> character.


# 使用正确的词描述事情

> 你们这样**地**热情，
> 但还是要提高自己**的**知识水平，
> 识**得**唔识得啊？

古人有一句话，
叫“学好的地得，走遍天下都不怕”。

这么想来，
那个苍蝇问的那句话还是颇有思想性的：
“假如当时我们把屎叫做饭会怎么样？”

[pangu]: https://github.com/vinta/pangu.js
[posix-line]: https://stackoverflow.com/questions/729692

