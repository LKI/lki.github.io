---
title:     "Pythonista 的 Go 之旅"
date:      "2019-06-13 01:10:49"
aliases:
  - /go-experience-as-a-pythonista
---

<!--more-->

# 背景

我们团队后端主要技术栈是 Python,
具体的软工实践在前文 [django/python][se-django] 里有详细的介绍。
由于平时做公司业务主要写的是 Python,
自己做的项目也是 Python 工具，
所以其实一直想尝试体验一下 Go。

正好上周有空，
于是体验了一下 Go 的基础设定，
用 Go 写了一个小服务（微信消息推送）。

这篇文章讲的就是一个 Pythonista 的 Go 萌新之路。
有理解谬误、操作不当的地方，
请各位多指教了。


# 语法

上手一个语言，
总是习惯性打开 [learn x in y minutes][go-xy] 先过一遍语法。

![go keyword][go-keyword]

Go 的特别之处是它的关键字非常少，
这让 Go 的语法很容易被记下来。
总的来说我觉得这几个语法很好玩。

## 循环

```go
// 直接 for 就可以写死循环
for {
    fmt.Println("while true...")     
}

// range 这个关键词用起来很舒服
data := map[string]string{
    "key": "value",
}
for key, value := range data {       
    fmt.Println("while true...")     
}
```

## 枚举

```go
// iota 居然被做成了关键字
// 这里后面的俩 iota 是可以省略的
const {
    Unknown = iota  // 0
    Male    = iota  // 1
    Female  = iota  // 2
}

// 也可以满足隔 10 定义枚举的喜好
// `iota << 2` 这样位运算定义 1/2/4/8 也是可以的
const {
    Unknown = iota * 10  // 0
    Male    = iota * 10  // 10
    Female  = iota * 10  // 20
}
```

## 多表达式判断

```go
// if 语句会取最后的表达式值，所以这么判断是很常见的
if f, err := file.Open(path); err != nil {
    return Response(400, err.Error())
}

// 这样判断布尔值也是常见的操作
if data, ok := json.Unmarshal(body); !ok {
    return Response(400, "invalid json body")
}
```

## goroutine

```go
// go 的天生并发也是非常优雅的地方
func sendTemplate() {
    // 这里是耗时很久的网络请求
}

func handleRequest(ctx Context) {
    validate()
    // sendTemplate()
    // ↑ 假如为了速度，我们不能同步发送模板，那么我们用 `go` 这个关键字就可以一键异步 ↓
    go sendTemplate()
}
```


# 项目

第一章的语法过了以后，
很快就到了第二章：
《如何用 go 起一个项目》

要写代码，首先就得把文档给翻出来看看。
于是第一站便是[官网 golang.org][golang-org]

Go 的官网其实非常友好，
从最基础的[教你怎么配环境、写初始的项目][golang-code]，
到 [Effective Go][golang-effective] 这种全面长文都浅显到点。

上手装好语言环境以后，
首先跟 `GOPATH` 这个环境变量玩了一下。
不过后来发现 Go 1.12 以后自带 go mod,
只要简单了解一下这个概念就行了。
那我们先放一下，
直接上手感受 Go 的工具链吧。

## 工具链

Python 装好以后主要自带的是个 REPL 跟 pip 这个包管理器。
Go 装好以后，会自带包括 fmt/test/vet/mod 等一系列的工具。

- `go fmt`
  - 这个是上手 Go 第一印象最大的工具
  - 它是一个不支持配置的代码格式化工具，非常严格
  - ~~prefer tab over space~~
- `go test`
  - 自带 coverage, 很好用
- `go vet`
  - 似乎是自带的 linter

玩 `go test` 的时候发现它是针对 `package` 来做测试的，
而 Go 里面，
`package` 的概念也是非常突出。
比如调用包方法的时候是要加包名的，
所以最佳实践里也有“命名不重叠”的规则。
（举个栗子，比如方法应该叫 `xml.Parser` 而不是 `xml.XMLParser`）

## 写业务

由于我们写的是一个对内网以 RESTful 风格提供接口，
然后调用微信发送消息通知用户的这么一个小服务，
按照 Python 的惯性就想找个 `django` + `wechatpy` 的组合在一周内来完成业务。
简单调研了一圈，选了 `gin` + `gorm` 两个大的工具。

Go 的第三方库给我的感觉是非常直白。
因为引入第三方库的方式是 `go get -u github.com/gin-gonic/gin`，
直接拉的就是 GitHub master 分支的最新代码，
所以感觉整个第三方的社区是基于分布式共识的，
只有大家都遵守社区规范，
才不会有挖矿代码的出现…（虽然中心化也会有挖矿代码）

文档的话，调研阶段读的其实都是 GitHub README，
GitHub 是经常逛的网站，
各个库的 README 风格也都是 markdown 风格，
读起来也很轻松。
真正要看 godoc 的地方不多。
因为拉的是源代码，
所以基本上都是直接读源代码，
体验跟 Python 非常像。

具体业务代码就先略过了，
没有什么特别的。


## 部署

开始准备部署的时候又有不少好玩的话题。
比如 Go 的多环境配置。

Python (Django) 的多环境我一直用的是环境变量 + 多配置文件，
Go 的话去看了一下社区，
基本也是类似的原理。
可以用环境变量，
也可以用多配置文件（比如 yaml），
还有一个就是用命令参数（flag 库）。
Go 社区里其实比较推崇用 flag，
因为这样可以把配置跟代码（执行文件）融为一体，
更加利于维护。
不过我最终还是选择了环境变量 + 多配置文件…

项目的编译、部署我们用的是 GitLab CI/Docker。
也是 ci-build/test/compile/docker-build/deploy 五个套路阶段。
Go 里比较特别的是会大量引用 GitHub 以及 Google 官方提供的代码，
在国内拉的速度比较慢，
所以为了加速构建，
我们也自己搭了相应的加速通道去提升速度。
目前来说，从代码进主干分支，
到自动发版大概耗时不超过 3min。


## 性能

自己写的小服务上去了，
那首先就要 wrk 一下测一下 QPS 啦。

Python(Django) 默认的其实是同步模式，
基础支持的 QPS 很低，
我们用 gevent + uwsgi 协程模式特意调优过，
一个获取服务器当前时间的简单接口，
在 1CPU+4G Memory 的小破机器上，
Python(gevent) 的 QPS 大概能到 1000，
而未经调优的 Go(gin) QPS 能到 10000。
真有你的啊，Go。


## 社区

在玩 Go 的一周中，
其实我真正的有效编码时间不是很长，
大部分时间都徜徉在 Go 的各种社区最佳实践文档里。

在我眼中，
除去 Go 语言本身的很多闪光点，
Go 的整个语言社区运营也是值得其他语言学习的。
比如上面讲到的官方推的工具链，
这能有效提升所有项目的下限。
Python 去年也刚出了[一个格式化工具 black][black]，
自己宣称是 **the uncompromising code formatter**。
（Python: 别催，在学了在学了）


# 感受

讲了这么多看似中立，
实际都是感受的发言，
我来集中总结一下我的感受。

## 我很菜

写 Go 的时候我是能直白地感受到自己很菜的。
一块是很多地方我能感知到有语法简化的可能性，
但我的语言表达能力还没达到优化的水瓶。
比如 [Go 2 Draft 里的 check 关键字][go-draft]，
我隐约感觉好像基于 `panic + recover` 也能实现类似的机制，
但真要写又写不出。
而 Python 我就感觉能完全写成 Lisp。

另一块是库的使用，或者叫“语言生态”。
不论是平时用到的标准库，
还是后端业务要用的各类三方库，
或是工程化用到的单元测试、质量把控的库，
我都只能在用到的时候做现场调研。

总之因为基础知识缺乏，
加上熟练度不够，
写 Go 的过程就总有一种“我好菜啊，这个都不懂”的奇妙感觉。

## 我喜欢 Go

菜并没阻止我表达喜欢 :)

Go 身上透露出了非常老派的 KISS 原则，
它甚至很多时候给我的感觉是比 Python 还要简约。
比如最佳实践会跟你说：
“不要过早拆文件，
一个目录十个文件能解决的问题不需要分层。”

相比 Python 而言，
Go 的执行速度透露着一种不讲道理的快。
Python 深入了解并发模型，
调优 CPU 跟语言参数以后的结果，
还是跟 Go 差了一个量级…
（不过开发速度上 Python 还是巨快…）

而且，
Go 还有可爱的 [Gopher][gopher] 呀~

![gopher-emoji][gopher-emoji]

## Go 的实践

目前我司后端的主技术栈是 Java 跟 Python，
我主要写的是 Python。

以我短暂的体验而言，
Go 在关键的高性能服务上会有很好的表现，
但在新业务的原型、Web 层的多业务上，
Python 魔法般的开发速度还是无人能比的（叉腰）

目前后端的各种流行框架基本都是语言无关的，
我们可以根据不同业务的适用场景来选择合适的技术栈。

企业在选择技术栈中，
其实也会考虑其它更现实的因素，
比如开发人员的招聘难度，
代码库、技术栈的统一，
大型团队的解耦管理。
这些其实也都是非常有深度的、值得探讨的话题。

写了一周 Go,
我更坚信自己的理念了：
“工程师是解决问题的人，
技术是解决问题的工具。
软件工程没做好说工具难用，
是何异于：
刺人而杀之曰，非我也，兵也？”


# 后续

一周的体验卡有点太短了，
非常意犹未尽。

后续有时间的话，
关于 Go 的这些话题我会继续研究：

- 产线环境上的服务部署姿势。
- Go 的服务可视化（监控、日志、追踪）
- 用黑魔法让语言表达力更高的基础库
- 跨语言服务间的交互实践

欢迎交流，
也对文章里的不当之处作出指正批评。

（完）


[black]: https://github.com/python/black
[go-draft]: https://go.googlesource.com/proposal/+/master/design/go2draft-error-handling-overview.md
[go-keyword]: /slides/golang-experience/reserved_words.png
[go-xy]: https://learnxinyminutes.com/docs/go/
[golang-code]: https://golang.org/doc/code.html
[golang-effective]: https://golang.org/doc/effective_go.html
[golang-org]: https://golang.org/
[gopher-emoji]: https://github.com/egonelbre/gophers/raw/master/.thumb/icon/emoji-3x.png
[gopher]: https://github.com/egonelbre/gophers
[se-django]: /software-engineering-django
