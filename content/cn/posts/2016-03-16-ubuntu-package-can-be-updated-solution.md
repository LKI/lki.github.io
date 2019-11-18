---
layout: post
title: Ubuntu系统X packages can be updated的解决方案
date: '2016-03-16 16:14:19'
enUrl: /ubuntu-package-can-be-updated-solution-en
aliases:
  - /ubuntu-package-can-be-updated-solution
comments:
  - author:
      type: twitter
      displayName: Triace210
      url: 'https://twitter.com/Triace210'
      picture: >-
        https://pbs.twimg.com/profile_images/715525829036355584/u__ldYW3_bigger.jpg
    content: '&#x5341;&#x5206;&#x611F;&#x8C22;'
    date: 2017-03-02T06:18:24.370Z

---

一个关于Ubuntu系统的小技巧。

<!--more-->


## x package can be updated

最近登录系统的时候，
系统老是提示

```
    x packages can be updated.
    y updates are security updates.
```

噢，就像AppStore上面的小红点一样，
更新一下就好了，
于是敲下命令：

```
    apt-get update
    apt-get upgrade
```

但是更新完以后，系统还是提示

```
    x packages can be updated.
    y updates are security updates.
```

[在查阅了资料以后][dist-upgrade]才知道，
`update` + `upgrade`不能更新完所有的软件包，
还要跑一条命令：

```
    apt-get dist-upgrade
```

这个有一点点小烦人的提示就不见了。


## MOTD

ubuntu开机时显示的这个Message叫
[MOTD(Message of the day)][motd]，
很多公司会让系统管理员定制自己服务器的MOTD。

Ubuntu系统里，MOTD的脚本默认放在`/etc/update-motd.d`下，
我们所看到的`x packages can be updated`就是由
`/etc/update-motd.d/90-updates-available`这个脚本提示的。

所以我们想彻底去掉这个提示的话，
可以把`/etc/update-motd.d/90-updates-available`这个文件删掉（不推荐）。

同理，我们也可以定制一下自己的MOTD。


## 总结

1. Ubuntu下更新全部包命令为`aptget update && apt-get upgrade && apt-get dist-upgrade`.

2. 系统一开始显示的Message叫[MOTD][motd]，默认放在`/etc/update-motd.d`下。

[dist-upgrade]: http://ubuntuforums.org/showthread.php?t=1222909
[motd]: https://en.wikipedia.org/wiki/Motd_(Unix)
