---
title: "Python 这几年都更新了啥"
date: 2021-10-21T20:26:58+08:00
aliases:
  - /whats-new-in-python-these-years
---

最近我们终于全线升到了 py39/go117,
在大家对 go 新特性兴奋之余，
@ackerr 提了一个很犀利的问题：
“Python 新版本都更新了啥？”

<!--more-->

确实，
除了 f-strings/dataclasses 这种大家可能熟知的功能，
新的版本究竟更新了什么呢？

以前 dota 一个小版本的 changelog 都能读的津津有味的我，
今天决定咀嚼一遍从 py36 至 py310 的更新日志 ~~（HOHO~~

> 以下代码片段都可以在最新的 Python 3.10.0 Repl 中执行。


# [What's new in Python 3.6][py36]

Python 3.6 是在 2016-12-23 发布的，官方维护至 2021-12-23。
感知比较大的几个改动包括：

```python3
# 字符串拼接中，支持使用 f-strings 的 inline 拼接方法
# 终于能像 JS 那样方便地进行字符串拼接了
name = "ackerr"
precision = 2
height = 183.2
assert f"{name} is {height:0.{precision}f}cm tall." == "ackerr is 183.20cm tall."

# 常数定义中，可以使用下划线增加可阅读性
number = 3_735_928_559
magic = 0xDEAD_BEEF
assert number == magic

# 变量定义中，支持类型声明了
# 值得注意的是 Python 依旧不是强类型，只是写在了 __annotations__ 这个变量里
import typing
numbers: typing.List[int] = [1,1,4,5,1,4]
complex_data: typing.Dict[int, typing.Set[int]] = {}
assert "complex_data" in __annotations__

# 加了一个 enum.auto 的函数，开发者不用费心去自增了
import enum
class Colors(enum.Enum):
    R = enum.auto()
    G = enum.auto()
    B = enum.auto()

assert Colors.B.value == 3
```

其它的一句话更新包括：

- Windows 上默认编码都设定为 `utf-8`.
- 修改了 dict 的实现，使其内存占用量比 py35 下降了 25%.
- 标准包 `asyncio` 更新了一大串功能，使其变得能用了.


# [What's new in Python 3.7][py37]

Python 3.7 是在 2018-06-27 发布的，官方维护至 2023-06-27。
感知比较大的几个改动包括：

```python3
# 类型系统支持惰性求值了，可以不需要用字符串来指代自己了
from __future__ import annotations
class QuerySet:
    def filter(self, **params) -> QuerySet:
        """some database filter"""


# 新增了 dataclass 标准包
# 相比于 dict 传参大大优化了可读性
import dataclasses as dc
@dc.dataclass
class Person:
    name: str
    age: int
    gender: str = 'Unknown'

assert Person('me', '24').gender == 'Unknown'
```

其它的一句话更新包括：

- `async`/`await` 现在是保留关键字了.
- 新增了 `breakpoint()` 系统函数用于调试.
- 可以通过定义包的 `__getattr__()` 来控制包变量的访问行为.
- 标准包 `time` 支持了纳秒级的精度.
- 标准包 `asyncio` 更新了一大串功能，使其变得好用了.


# [What's new in Python 3.8][py38]

Python 3.8 是在 2019-10-14 发布的，官方维护至 2024-10-14。
感知比较大的几个改动包括：

```python3
# 新增了赋值判断的语法（也被形象地叫做海象操作符）
import re
if match := re.search(r"(\d+)%", "Total coverage: 80%"):
    print("Coverage is {match.group(1)}")

# 函数支持用 `/` 限制非命名参数
def calculate_data_length(data, /):
    pass

# 官方指出，这种情况 `calculate_data_length(data=data)` 的可读性显然更低，其实可以在定义函数时禁掉
# 而且该语法可以避免 `**kwargs` 传参冲突的情况
def get_values(data, /, **kwargs):
    print(data, kwargs)

get_values({}, data='some_data')

# f-strings 支持了自解释的语法
name = "ackerr"
assert f"Debug: {name=}" == "Debug: name='ackerr'"

# 新增了 `functools.cached_property` 方法，支持属性的缓存
import functools
class DB:
    @functools.cached_property
    def connection(self):
        print(1)

db = DB()
assert db.connection == None
assert db.connection == None
```

其它的一句话更新包括：

- `finally` 语句中不允许使用 `continue` 了.
- 新增了计算欧几里得距离的方法 `math.dist()`.
- 新增了支持混合l类型的 `typing.TypedDict`.
- 标准包 `asyncio` 更新了一大串功能，使其变得稳定了.
- 官方给出的 benchmark 中，相比于 py37 总体性能提升了 5%~20%.


# [What's new in Python 3.9][py39]

Python 3.9 是在 2020-10-05 发布的，官方维护至 2025-10-05。
感知比较大的几个改动包括：

```python3
# dict 支持并集操作符 `|` 了
x = {"a": 1, "b": 2}
y = {"b": 3, "c": 4}
assert x | y == {"a": 1, "b": 3, "c": 4}
assert y | x == {"a": 1, "b": 2, "c": 4}

# 支持 `list`/`dict`/`set` 这样的原生类型作为类型标注
def occurance(names: list[str]) -> dict[str, int]:
    return {name: names.count(name) for name in names}
```

其它的一句话更新包括：

- 编译器由基于LL, 改为了基于PEG, 以便日后提供更强大的语言特性.
- 新增了 `str.removeprefix()`/`str.removesuffix()` 方法.
- `hashlib` 支持了 `SHA3`/`SHAKE` 的计算.
- 非 Windows 平台不支持构建 `bdist_wininst` 了(所以很多第三方库没及时更新).
- 官方给出的 benchmark 中，相比于 py37 总体性能并无提升.


# [What's new in Python 3.10][py310]

Python 3.10 是在 2021-10-04 发布的，官方维护至 2026-10-04。
感知比较大的几个改动包括：

```python3
# 新增了类似 switch+case 的 match+case 语法
def check(status_code: int, message: str):
    match status_code:
        case 200 if message:
            return message
        case 200:
            return "ok"
        case 400:
            return "bad request"
        case 500 | 502 | 503:
            return "something wrong"
        case _:
            return "not implemented"

# `typing.Union` 可以写成更优雅的 `|`
def add_all(*numbers: int | float) -> int | float:
    return sum(numbers)

assert isinstance(42, int | float)

# `dataclass` 支持 keyword-only 模式
import dataclasses as dc
@dc.dataclass(kw_only=True)
class Person:
    name: str
    age: int
    gender: str = 'Unknown'
```

其它的一句话更新包括：

- 优化了 Python 自带的各种报错信息.
- 增加了 `zip(*args, strict=True)` 强制校验等长的参数.
- 优化了 `str()`/`bytes()` 的性能，日常情况中快了 40%.


# 结语

可以看到 Python 作为一个“步入成年的”编程语言，
这几年并没有 Golang 的泛型、错误处理那样令人 excited 的更新。
但总体的语言迭代也是基于 Python Zen 的小步快跑。

对于开发者而言，只要第三方依赖允许，
保持最新的环境并不是一个很难的事情。

笔者关心的功能只是语言标准的一个子集，
读者们也可以在官网上找到更详细、更实在的 changelog。

下期（如果还有的话）可能会带来 go115-go117 的版本变更日志，
到时候再见 :)

（完）


[py36]: https://docs.python.org/3/whatsnew/3.6.html
[py37]: https://docs.python.org/3/whatsnew/3.7.html
[py38]: https://docs.python.org/3/whatsnew/3.8.html
[py39]: https://docs.python.org/3/whatsnew/3.9.html
[py310]: https://docs.python.org/3/whatsnew/3.10.html
