---
title:     "一种轻量级的Http加密方式：Hawk"
date:      "2017-03-18 23:55:18"
aliases:
  - /hawk-authentication
---

这是一篇关于[Hawk][hawk]的简短介绍。

<!--more-->

## 什么是Hawk

[Hawk][hawk]是一种轻量级的Http加密方式，
这里的轻量级是针对于OAuth / Digest这种加密方式而言。
[Hawk][hawk]主要防范的是中间人攻击，
它基于服务器和客户端共有的秘钥，
在时间戳的基础上对请求加密，
生成互相匹配的特征码。

[Hawk][hawk]的好处是整个加密的过程对计算能力要求不高，
用到的也是简单的sha256算法。
而且它可以只针对单个请求加密，
所以应用场景十分灵活。

在一个典型的[Hawk][hawk]应用场景中，
客户端首先通过某种方式跟服务端通信，
获取秘钥。
在之后的Http请求中，
客户端对请求采用Hawk加密，
并且把基本信息放在Http Header里。
服务器收到请求以后，
采用同样的方式进行加密比对，
假如两边都对上了，
则是一个合法请求。
否则返回`401 Unauthorized`

## 加密算法

[Hawk][hawk]协议规定的加密方式如下：

这是一个样例的HTTP GET请求：

``` http
GET http://example.com:8000/resource/1?b=1&a=2
```

要通过Hawk验证，
我们会把请求的特征用换行符拼接成如下格式，
最后再用`HMAC sha256`进行加密：

``` http
hawk.1.header
1353832234
j4h3g2
GET
/resource/1?b=1&a=2
example.com
8000

some-app-ext-data

```

其中`hawk.1.header`是表示用version为1的hawk来加密header，
`1353832234`是unix timestamp，
`j4h3g2`是客户端生成的随机字符串，
`GET`是请求类型，
`/resource/1?b=1&a=2`是请求的query，
`example.com`和`8000`分别是host和port，
而`some-app-ext-data`是约定好要验证的额外内容（可为空）。
上面这段字符串是大小写敏感，空格敏感且换行敏感的。

假如说我们的秘钥是`werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn`，
则上面的样例请求经过`HMAC sha256`加密后的特征码会是`6R4rV5iE+NPoym+WwjeHzjAGXUtLNIxmo1vpMofpLAE=`

最后我们把基本信息加入Http Header里，
请求就会变成这样子：

``` http
GET http://example.com:8000/resource/1?b=1&a=2
Authorization: Hawk id="dh37fgj492je", ts="1353832234", nonce="j4h3g2", ext="some-app-ext-data", mac="6R4rV5iE+NPoym+WwjeHzjAGXUtLNIxmo1vpMofpLAE="
```

服务器端拿到`HttpHeader.Authorization`以后进行加密比对即可。

## 其它事项

* Hawk提供Payload Validation，协议中指定的加密方式是`sha256`，与header的加密方式`HMAC sha256`不一样。
* 假如客户端和服务器的Timestamp不一样，服务器应当返回Timestamp，由客户端计算时间差后再次请求。
* 具体使用中可恰当魔改Hawk请求，比如增加对id的验证等。

[hawk]: https://github.com/hueniverse/hawk1
