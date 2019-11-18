---
title:     "我是怎么实现《用弹幕玩GBA游戏》的"
date:      "2018-01-06 18:58:33"
aliases:
  - /play-gba-with-danmaku
---

大概是大二的时候，
我在TwitchTV上看到了一个极其精彩的Idea。

<!--more-->

## 背景

[TwitchTV][twitch]是外国的一个主要做游戏直播网站，
观众可以打开网页观看游戏直播，
每个人都能随时发弹幕表达自己的想法。
[_弹幕是啥？_][danmaku]

依赖于发弹幕万人同屏的这个设定，
TwitchTV做了一个很好玩的功能，
就是“几千人玩操纵同一个角色，玩同一个游戏。”
[_详情可以参见Twitch Plays Pokemon这个维基词条_][tpp]

当时看到这个消息，
我也去玩了一下，
感受是：特别好玩！！！

几千个人同屏玩游戏的话，
最大的感受就是**混乱**，
这也是最棒的体验。
大部分玩家是冲着通关的目标去玩的，
所以总体看来，角色的行为是有目标性的。
但是也会有一部分玩家以捣乱为乐，
在一些精细操作的时候（比如收服Pokemon的时候）
就会额外混乱。

最终整个游戏（或者说社会实验）在混乱中前行，
经过了16个日夜，
最终打过了四大天王，
完成了通关壮举。

OK，前面都是背景介绍，
那么看到这么好玩的一个东西，
我的心痒了很久：
我也想实现一个类似的功能！


## 实现

就像把大象塞冰箱里需要拆解步骤，
为了实现“用弹幕玩同屏GBA游戏”这一点，
我们主要要做的事情有如下几点：

1. 申请一个直播间
2. 获取直播间的弹幕
3. 实现从弹幕到键位的映射
4. 用程序操纵GBA模拟器

当然，我们这个拆分非常的粗略，
而且会有很多具体的问题，
我们一个一个地来看。


### 申请一个直播间

我要没记错的话（_懒得去查资料验证了_）
TwitchTV的同屏玩游戏功能应该是官方实现的，
不是某一个主播或者是我这样的第三方程序员实现的。
平台自己实现的话会有非常多的自主权，
而且可以给到游戏本身的推广，
一波活动推出去不论是效果还是效果都会更好。

但是毕竟人微言轻，
我们普通人类还是要从头开始，
从申请直播间开始。

申请直播间的话主要是涉及到直播平台的选择，
因为我一直都是A/B站用户，
所以直播平台基本上就是斗鱼[（A站生放送）][shengfangsong]和B站直播之间选一个。

最终我两年前注册了一个斗鱼直播间
（打个广告，从来不播的直播间：[douyu.com/lisp][lisp]）

第一步算是做完了。


### 获取直播间的弹幕

这个是个非常interesting的问题。
首先他受前置问题的影响，
带来的现实问题是**每个直播平台获取弹幕的难度是不一样的**。

斗鱼和B站直播相比，
看斗鱼的人肯定是更多的，
但是受氛围和观众群体的影响，
[会为B站写插件的程序员][vim-bilibili]更多_CITATION NEEDED_。

但毕竟我们在上一个步骤选择了斗鱼，
还是得从一而终。
于是两年前我就在知乎关注了[《如何获取斗鱼直播间的弹幕信息？》][zhihu-douyu-danmu]这个问题，
顺便学习了一波socket相关知识（对，这句话反映了我的真实水平...）

当时没有一套好用的库，
我又懒得自己钻研，
所以就卡在这里了。

后来我[在GitHub闲逛的时候][play-github]，
发现itchat的作者写了一个包，
支持获取各大直播平台的弹幕，
感觉就是我要的轮子！
[于是我点了一个star先马克着][danmu]。

今天是2018年1月，
这个库最近的更新是2017年5月，
有大半年没更新代码了。
正式采用之前我试了一下，
斗鱼的弹幕是没问题的，
不过B站的弹幕因为是直接[解析网页原文拿ROOMID][roomid]的，
已经失效了。
又因为这个库（或者说littlecoder这个人）不是很Pythonic，
于是我心中又暗立一个flag，
fork了这个项目，
想着啥时候摸鱼摸够了就去改进一波。

于是最终我采用了danmu这个库，
几行代码就成功地获取了斗鱼弹幕，
大概代码（伪）如下：

```
import danmu

client = danmu.DanMuClient('http://www.douyu.com/lisp')

@client.danmu
def receive(message):
    print('[{}] {}'.format(message['NickName'], message['Content']))

client.start()
```

### 实现从弹幕到键位的映射

这个没什么可以说的，
就是业务逻辑/苦力活。
简单。跳过。


### 用程序操纵GBA模拟器

好，这里首先有个坑。
我们回忆一下，
最开始我们的目标其实是“实现用弹幕玩GBA游戏”，
现在的这个小步骤被回归成了“用程序操纵GBA**模拟器**”。
这模拟器的需求是哪冒出来的？

嗨呀，这个是有苦衷的。

首先，我对GBA的回忆除了实体机，
有一半都是[`VisualBoyAdvance.exe`][vba]这个模拟器给的。
还有就是理论上我们也可以实现Web版的，
或者自己撸一个GBA模拟器，
但那样又相当于额外的工作量了。
所以基于“把我不会的目标拆成我能做到的小步骤”
和“鲁迅说过，不要重复造轮子”这两个设定，
我就把“用程序玩GBA游戏”拆分成了“用程序操纵GBA模拟器”+“用GBA模拟器玩GBA游戏”（现成的）这两个任务了。

OK，我们来现实地看第一点：
“怎么用程序操纵GBA模拟器”。

在我的脑海中，
假如用Python来实现，
基本上这个就是Python调用windows库 + windows库给程序传递信号 + 程序接收信号达成效果，
这样一套combo下来就行了。

虽然我平常开发环境是windows，
但其实我对windows的接口是一窍不通（暴露水平 x2）
不过不懂可以问啊！
于是前几天我问了一下身边的windows大拿hulucc，
他表示[windows有个叫sendkey的API][sendkeys]可以做这个，
不过只能操纵active window。
后来他又查了一下，
跟我说Python里有个`pywin32`的库可以调用windows接口，
又发了一篇文章 [How to Build a Python Bot That Can Play Web Games][py-bot]
给我参考。

学习了这么一大段以后，
我十分感动，
然后自己找了个另外的库[keyboard][keyboard]（雾）

事实是后来我回来研究了一下，
用windows接口肯定能达到我的目的，
但是问题是[pywin32或者是类似的pypiwin32这俩包没有合适的pip release要手动安装][pywin32-install]，
这让我很不舒服。
刚好google的同时，
我搜到了另外一个python库[`keyboard`][keyboard]，
它的主页长得还蛮好看的，
也能达到我的需求，
不错，就这个了。

于是实现了接收弹幕+发送按键的代码（伪）就大概长这样子：

```
import danmu
import keyboard
import constants

client = danmu.DanMuClient('http://www.douyu.com/lisp')

@client.danmu
def receive(message):
    print('[{}] {}'.format(message['NickName'], message['Content']))
    content = message['Content']  # 主要是新增了这行和下面的if
    if content in constants.valid_keystrokes:
        keyboard.send(content)

client.start()
```

### 一个小坑

这里还遇到了一个小坑，
简单来说就是VisualBoyAdvance这款GBA模拟器（以下简称VBA）
它应该是通过监控键盘事件来转化键位的。
（此句描述不够专业）

转化成代码语言就是`keyboard.send(content)`这行代码对VBA不起作用。
经过思考加尝试以后，
最终使用了`keyboard.press(content)` + `time.sleep(0.02)` + `keyboard.release(content)`三个combo达成了效果。

最终不禁要感慨一下：
上面这段描述里的**经过思考加尝试**，
就是写程序这件事情最痛苦也是最美好的所在了。


## 总结

上面讲的比较零碎，
总结下来：

为了做到 “用弹幕玩GBA游戏” 这个事情，
被拆分细化完成的任务有这些：

* 注册直播间，选了斗鱼。
* 获取直播间弹幕，平常关注一波信息，最终用了danmu这个库。
* 实现业务逻辑。
* 用程序操纵GBA模拟器来玩GBA游戏，使用了keyboard库发送键位信息。

最终的成品在我的GitHub上：[LKI/danmaboy][danmaboy]这个项目，
有效代码就100行，就在[danmaboy/\_\_init\_\_.py][init.py]一个文件内。

一下午就写完了，
不过中途摸鱼思考的时间用了几年（惭愧）

下午写代码的时候我还做了一个尝试，
就是开着直播写代码，
不过因为没人看（现实的原因），
所以总体感受跟小黄鸭编程差不多，
写一会儿，就紧张地想一下思路，
效果意外的不错。

最终成品出来以后，
试着在直播间里跑了一下，
~~创业失败~~遇到了一个基石上的失误：

**因为是游戏，所以普通的弹幕延迟在这个项目上会放大到极度影响游戏体验**

基本上就是发一条弹幕，
15秒以后才会有对应的游戏变动，
别说TwitchTV那样的效果了，
就是基本的自己玩玩都玩不动…

叹气。

不过好歹是我心里很多idea之一了，
这篇文章也算是给这个项目画个句号吧。

我的心中还有很多未竟的事业，
有兴趣的话，
欢迎和我交流噢~

下次见。

![screen][screen]
_直播时的画面截图_

[twitch]: https://www.twitch.tv/
[danmaku]: https://zh.moegirl.org/zh-hans/%E5%BC%B9%E5%B9%95
[tpp]: https://en.wikipedia.org/wiki/Twitch_Plays_Pok%C3%A9mon
[shengfangsong]: https://www.zhihu.com/question/27088840
[lisp]: https://www.douyu.com/lisp
[vim-bilibili]: https://github.com/feisuzhu/vim-bilibili-live
[play-github]: /how-i-use-github
[danmu]: https://github.com/littlecodersh/danmu
[roomid]: https://github.com/littlecodersh/danmu/blob/master/danmu/Bilibili.py
[zhihu-douyu-danmu]: https://www.zhihu.com/question/29027665
[vba]: https://en.wikipedia.org/wiki/VisualBoyAdvance
[sendkeys]: https://msdn.microsoft.com/en-us/library/system.windows.forms.sendkeys(v=vs.110).aspx
[py-bot]: https://code.tutsplus.com/tutorials/how-to-build-a-python-bot-that-can-play-web-games--active-11117
[keyboard]: https://github.com/boppreh/keyboard
[pywin32-install]: https://stackoverflow.com/questions/4863056/how-to-install-pywin32-module-in-windows-7
[danmaboy]: https://github.com/LKI/danmaboy
[init.py]: https://github.com/LKI/danmaboy/blob/master/danmaboy/__init__.py
[screen]: /assets/pics/screen.png

