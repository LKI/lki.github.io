---
title:     "URL中参数编码不正确的解决方案"
date:      "2016-06-07 21:29:39"
aliases:
  - /encoding-in-url
---

说是说解决方案，其实并没有解决这个问题 :wink:

<!--more-->

## URL中参数编码不正确

最近在做Python-Scrapy的爬虫，用Tornado写了一个服务器程序，
但是遇到的问题是

**Tornado无法解析URL的中文**

比如说样例小程序如下：

``` python
from tornado.ioloop import IOLoop
import tornado.web as tw

class SampleHandler(tw.RequestHandler):
    def get(self, path):
        self.write(path)

app = tw.Application([(ur'/(.*)', SampleHandler)])
app.listen(8080)
IOLoop.current().start()
```

但是访问`http://localhost:8080/浮云计算`却只能得到`æµ®äº�è®¡ç®�`这样一坨东西...

## 解决方案

长话短说，这是因为`URL中文解码不正确`的原因导致的。
所以我们利用[站长工具url编码][urlencode]手动替换中文访问即可：

访问`http://localhost:8080/%e6%b5%ae%e4%ba%91%e8%ae%a1%e7%ae%97`就可以得到`浮云计算`啦。

## 详细原因

一开始我怀疑是因为字符串没用utf8编码，
于是尝试了不同的转换方式：

```
self.write(str(path))
self.write(unicode(path))
self.write(path.encode('utf8'))
```

这些常识不是报错，就是根本没变化。

最终我找到了[一个前人的经验][outofmemory]，里面是这么讲的：

> 看来你是不知道在浏览器地址栏手动输入中文和在页面上一个的链接的编码处理方式是不同的。。。。
> 打个比方，在windows系统上，你在FF地址栏输入"http://localhost/中文.html?m=汉语"，这里的“中文”两字的编码是utf8（这一点应该是跟浏览器设置相关），而“汉语”则是gbk，跟操作系统相关（大部分中国人的windows应该都是cp936，也就是gbk）。
> 如果你是通过某个页面访问这个链接的，则所有字符的编码都是跟页面的编码相关。
> 在IE上也是一样。
> 所以，我觉得还是打消在浏览器地址栏输入中文这个想法吧，要不然你要解码两次，而且还要保证页面上的编码跟系统一样，不然无法保证手动输入和页面点击的兼容性。。。。


喔，原来是因为`URL解码方式完全取决于浏览器和操作系统`，也就是说`中文有可能以GBK来编码`

怪不得Python/Tornado认不出来了！

所以解决方案就是我们手动去解码一次啦~

（或者Python3 XD）

[urlencode]: http://tool.chinaz.com/tools/urlencode.aspx
[outofmemory]: http://ju.outofmemory.cn/entry/62161
