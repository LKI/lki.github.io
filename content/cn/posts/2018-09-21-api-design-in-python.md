---
title:     "优雅的 Python 接口设计"
date:      "2018-09-21 20:57:46"
aliases:
  - /api-design-in-python
---

今天跟[@hulucc][hulucc] 日常写码吹比，
讲到了选第三方库的原则说：
“我其实发现我现在选库不太 care 他源码是怎么实现的，
但是我非常喜欢那些 api 设计得巨科学的库。”

<!--more-->


## 科学的 API

API 设计的科学大概是什么样的呢？
比如举一个有名的例子就是 [requests][requests] 这个库。

> Requests is one of the most downloaded Python packages of all time,
> pulling in over 11,000,000 downloads every month. 

这个库的 API 用起来大概是这样的：

```
>>> response = requests.get('https://api.github.com/user', auth=('user', 'pass'))
>>> response.status_code
200
>>> response.headers['content-type']
'application/json; charset=utf8'
>>> response.encoding
'utf-8'
>>> response.raise_for_status()
```

这里设计的所有 Python 程序语言都是见文知意的英文人类语言，
`requests.get` 中的 `requests` 不仅是包名，
还化身成了代码语义的一部分。
返回的 `response` 就是一个典型的 HTTP 协议对象，
只要对 HTTP 协议有一定了解的程序员，
基本上不用看文档都能猜到它的主要属性和相关作用。
对应还有便捷的 `.raise_for_status()` 和 `.json()` 这样的常用方法。
这就是科学的 API 给我的感受。

当然，库的作者（也就是那个帅哥 [Kenneth Reitz][kennethreitz]）也清楚自己的代码接口优雅，
他的个人签名也是这么说的：

> I wrote @requests: HTTP for Humans.
> The only thing I really care about is interface design.
>   -- Kenneth Reitz


## 不科学的 API

大部分开源高星项目的接口都是比较优雅的，
那么不科学的 API 大概是什么样子呢？
唔，我的话，翻一翻自己两三年前的代码，
就满是不科学的 API 实现了。

最早接触 `**kwargs` 这个东西的时候，
我非常喜欢用这个语法，
比如我常常会写这么一种函数：

```python
class Record:
    def create(**kwargs):
        now = kwargs.get('now', datetime.datetime.now())
        key = kwargs.get('key')
        value = kwargs.get('value')
        ...
```

这样写的好处是看起来灵活的一比，实现起来爽。
以后假如要加参数，
往往只要在 `record.create` 里面加一个新的 `kwargs.get` 就行了。
然而在大部分情况，这样的实现只会把参数给隐式化：
记不住参数调用 `record.create` 的时候还得进函数看实现；
而且万一把 `value` 拼错成了 `valeu`，
函数是会像某些语言一样正常运行的！
然后会在后面某个地方报错，
这样就很难方便找出根源了。

后来我大部分情况会这么写：

```python
class Record:
    def create(now=None, key=None, value=None):
        if now is None:
            now = datetime.datetime.now()
        ...
```

这样的显式调用强制要求参数的正确性，
虽然实现起来要写的参数多了，
但是调用和阅读的时候更加明确。

```
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

后来我看到 `The Zen of Python` 的这句 `Explicit is better than implicit` 总会想到这个例子。
（关于 Python 接口参数设计的，有一篇我觉得说的很好的知乎文章：
[《Python函数接口的一些设计心得 - 灵剑》][method-signature]）


## 例子

`The Zen of Python` 里还有非常多珠玑可以挖掘。
比如在做的一个项目 [hutils][hutils]，
想着把公司里各种 Python Web 中常用到的函数抽出来做个基础库，
结果写的时候 80% 的时间都在想怎么让 API 变的更科学。

比如我们写后端的时候，
经常会遇到要转化框架错误类的情况：

```python
def service_call(...):
    try:
        external_service.call()
    except ExternalServiceError as ex:
        log_error(ex)
        raise APIError('Error calling external service')
```

对应的，我们会有个这样的装饰器来封装错误处理：

```python
@contextlib.contextmanager
def catches(*exceptions,
            raise_to: BaseException = None,
            raise_from: Callable[[Exception], BaseException] = None,
            log=False,
            ignore=False):
    try:
        yield
    except exceptions as ex:
        if log:
            log_error(ex)
        if not ignore:
            if raise_from:
                raise raise_from(ex)
            else:
                raise raise_to  # pylint: disable=raising-bad-type
```

有了封装的装饰器以后，
简单的错误转化就可以跟业务代码相分离：

```python
@catches(ExternalServiceError, raise_to=APIError('Error calling external service'), log=True)
def service_call(...):
    external_service.call()
```

但是这样的装饰器实现会在 Code Review 阶段就会被像 [@hulucc][hulucc] 这样的铁血队友锤回来，
这样的 API 实现有几个不够科学的地方：
* `raise_to` 和 `raise_from` 有重叠之处，
  而且调用者不注意的话会触发 `raise None` 的问题，
  连 `pylint` 都注意到了。
  应当使用类型判断来合并参数。
* 这样错误转化，原错误类的堆栈信息会丢失。
  应当使用 `raise ... from ...` 的语法来保留堆栈信息。
* `transfer`/`ignore`/`retry` 其实是相对独立的逻辑，
  混合处理当然可以，
  不过最好的情况是逻辑拆分，独立处理。

一波讨论以后，
顺带顺手支持 `catches(Exception, raises=raise_api_error)` 的快捷写法，
装饰器的实现就改成了这样子。

```python
@contextlib.contextmanager
def catches(*exceptions, raises: Union[BaseException, Callable[[Exception], BaseException]], log=False):
    exceptions = exceptions or (Exception,)
    try:
        yield
    except exceptions as ex:
        if callable(raises):
            raises = raises(ex)
        if log:
            log_error(__name__, raises)
        raise raises from ex
```

感觉更加优雅了呢。


## 结语

Python 因为语法及其灵活，
所以其实接口的设计是全看程序员的设计水平的。
但往往科学又优雅的实现就像 `There should be one-- and preferably only one --obvious way to do it` 这句话说的一样，
是万中取一的。

不仅要实现功能，
还要优雅，不要污。
看来写程序的确是要想得多，
怪不得程序员会头发少呀 :)

（完）

[hulucc]: https://github.com/hulucc
[requests]: https://github.com/requests/requests
[kennethreitz]: https://github.com/kennethreitz
[method-signature]: https://zhuanlan.zhihu.com/p/25017419
[hutils]: https://github.com/zaihui/hutils
