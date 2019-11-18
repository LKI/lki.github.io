---
title:     "0x5f3759df 一个神奇的数字"
date:      "2014-03-07 14:11:31"
aliases:
  - /magic-number
---

今天在看各种算法介绍的时候看到了这么一句话“神奇数字0x5f3759df并不是约翰·卡马克发明的。之所以一开始被误解，主要是许多对卡神光环膜拜已久的游戏程序员在读Quake3源码时吓尿了……”一下子引起了我的好奇心，在查阅了一些资料以后整理整个故事如下。

<!--more-->

## 雷神之锤3

雷神之锤3（Quake3）是90年代的经典FPS游戏，不仅画面精美，而且整个程序优化得很好，在配置一般的电脑上也能流畅地运行。这主要归功于其3D引擎id Tech3，而此引擎是由约翰·卡马克（John Carmack）领导开发的。

卡马克是一个美国码农，id Software的创始人之一，他因在3D技术上的杰出成就而文明。卡马克还是一个开源软件的倡导者，1996年他放出了雷神之锤的源代码，而一个程序员将其改写成了Linux的版本并发给了卡马克。卡马克没有认为这是侵权，反而是要求他的员工们以这个补丁为基础开发雷神之锤的Linux版本。后来的日子id Software也一样公布了雷神之锤2的源代码，在2005年，雷神之锤3的源代码也被放出来了。

（这是官方下载地址ftp://ftp.idsoftware.com/idstuff/source/quake3-1.32b-source.zip）

我们知道，越底层的函数调用越频繁，假如把底层函数优化做好了，效率自然就上去了，3D引擎归根到底还是数学运算。在最底层的运算函数中（game/code/q_math.c中），有许多有趣的函数，有些更是令人惊叹这究竟是如何编写的。


## 神奇的0x5f3759df

在运算函数文件中可以找到这么一个函数，它的作用是将一个数开方并取倒数，功能上跟系统函数(float)(1.0/sqrt(x))一样，但是效率上快了四倍：

```
float Q_rsqrt( float number )
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;
     
    x2 = number * 0.5F;
    y = number;
    i = * ( long * ) &y;         // evil floating point bit level hacking
    i = 0x5f3759df - ( i >> 1 ); // WHAT THE FUCK?
    y = * ( float * ) &i;
    y = y * ( threehalfs - ( x2 * y * y ) );       // 1st iteration
    // y = y * ( threehalfs - ( x2 * y * y ) );    // 2nd iteration, this can be removed
     
#ifndef Q3_VM
#ifdef __linux__
    assert( !isnan(y) ); // bk010122 - FPE?
#endif
#endif
    return y;
}
```

这个函数最核心，最令人费解的就是标注了“WHAT THE FUCK”的那一句

`i = 0x5f3759df - ( i >> 1 );`

再加上一句`y = y * ( threehalfs - ( x2 * y * y ) );`就完成了求开方的运算。

一般的求开方采用的都是牛顿迭代法，比如求sqrt(5)，那么先令A = 2然后B = 5 / A; A = (A + B) / 2;这样循环下去，A和B将会越来越接近，最终的结果就是根号五了。而卡马克给出的这个算法的牛逼之处在于它直接用了0x5f3759df一个数猜测了一个值，通过一次计算就很接近根号N的值了。这样省下了许多次迭代逼近的过程，那么函数效率则也就大大被优化了。

普渡大学的数学家Chris Lomont了解到了这个数字以后很感兴趣，他打算研究一下这个数字的奥秘。这个Lomont也是一个牛人，精心研究以后他从理论上推导出了一个最佳猜测值：0x5f37642f，跟程序中的0x5f3759df十分接近。Lomont得出这个结果以后很满意，他拿自己这个数跟卡马克的神奇数字做速度比赛，结果卡马克赢了……谁也不知道卡马克是怎么求出这个数的……

自己精心推导出的理论最佳值居然输给了卡马克，Lomont也是很不甘心，他用类似穷举的方法一个个地试过来，终于被他找到一个比卡马克的0x5f3759df要好一丁点的数字：0x5f375a86。于是Lomont很高兴地把这个结果写成了论文公之于世……（论文地址：http://www.matrix67.com/data/InvSqrt.pdf）

这个算法也有了自己的名字：平方根倒数速算算法（Fast Inverse Square Root）


## 算法的发明者

因为约翰·卡马克是整个雷神之锤项目的开发者，所以起初很多人也就简单的认为神奇数字0x5f3759df是卡马克的杰作。但是后来卡马克本人在回复问询邮件的时候否定了这个观点，卡马克回忆可能是雷神之锤项目的一个资深码农Terje Mathisen写下了这段代码。而Mathisen回复邮件则表示他以前的确写过类似的代码，但他并不是先行者。现在了解到最早的实现是Gary Tarilli在SGI Indigo中实现的，但他也表示他只是对常数进行了一些改进，实际上他也不是作者。

虽然并没有定论表示整个算法究竟是谁发明的，但是大家还是津津乐道于卡马克、和他的神奇数字0x5f3759df。
 
 
> 参考资料：
> http://www.guokr.com/post/90718/
> http://www.matrix67.com/data/InvSqrt.pdf
> http://www.matrix67.com/blog/archives/362
> http://en.wikipedia.org/wiki/Fast_inverse_square_root
> http://en.wikipedia.org/wiki/John_Carmack
> http://zh.wikipedia.org/wiki/%E5%B9%B3%E6%96%B9%E6%A0%B9%E5%80%92%E6%95%B0%E9%80%9F%E7%AE%97%E6%B3%95
