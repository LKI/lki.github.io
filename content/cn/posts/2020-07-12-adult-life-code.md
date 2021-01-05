---
title: "毕业五年的报告之技术"
date: 2020-07-12T23:45:58+08:00
aliases:
  - /adult-life-code
---

16年接触了 Web 整套技术栈的我，
决定在这条路上不断攀爬，
直到找到我技术上的天花板。
当时我写了一篇[《后端工程师技能树》][tree]。

<!--more-->

现在回过头再看，
我并没有按照叶子节点的顺序去一步步做。
除了系统地学习了解技术知识以外，
我更多是在“明天上线”以及“线上挂了”的血与火的泥泊里扑腾。

这篇就以不同的视角，
记录一下我这几年技术上的感悟吧。
由于讲述的更偏 Web，
所以本篇基本都是以再惠的实际开发为例。


## 项目、语言与框架

16年的时候，公司的业务在一个大主站里就可以完全解决了。
这单个项目不仅包括了全部后端代码，
还包括了全部前端代码（不过后来前端就拆出去了）

当时用的是 Python 2.7 + Django 1.8,
不过由于 Python2 在生命的末期，
后来我们就[找了个周末升级到了 Python 3.5][py3]。
顺带一提，当时不升 Python 3.6 的原因是 Ubuntu 16 默认带的是 Python 3.5。

Python 是一门非常容易上手的语言，
我进再惠前其实没有认真用过（连 virtualenv 都不知道是什么，只会 print），
但很快就可以开始参与业务开发了。
整个主站在开发周期里，
框架没有大的变动，
基本上是前人怎么写的，后人就怎么写。

当时我在语言上感兴趣的几个点，主要包括：

- magic method 与元编程：于是我实现了一套根据配置生成接口的逻辑
- 性能、并发与处理能力：于是我们经常在小黑板上画各类网络架构图
- 不同框架之间的对比：于是我们内部后面的项目尝试使用了 flask/tornado 等各类框架
- 关于语言本身的话题：于是我们内部每天都在讨论[垠神@wangyin 的博客][wangyin]（x

后来业务线逐渐开始变多，
我也有机会从零开始搭建一个项目。
因为是从零开始，所以我心中暗想：
“以前很多东西我都是知其然不知其所以然，
这次项目的所有方面我都要完全理解才行。”
于是那个月所有的业余时间我都在读各种文档…

不读不知道，一读吓一跳。
我发现我以前默认的很多习惯用法，
其实都有更佳的实践：

- **轻度使用**：
  以前项目里会搭配着使用 djangorestframework,
  但我们从来都是手写各种序列化类，
  并没有使用框架自带的 django model 支持。
  而且我们自己实现了一套 schema 验证系统，
  既没有用 djangorestframework,
  也没有用 marshmellow 这样的库。
  （这导致了后面支持 swagger 非常困难）

- **缺少检查**：
  Python 社区中有非常多的检查工具，
  但我们只用到了最基础的 flake8 来验证 PEP8 风格。
  我们在合作编程中，
  因为每个人 PyCharm 配置的不一样，
  解了无数次 import 的冲突。
  （更别提还有数组末行加逗号的冲突了）

- **版本老旧**：
  我们用的很多三方库一直保持着版本更新，
  但我们却一直用着旧的版本（更别说语言本身了，f-string 我们也是老后面才用上的）

这些问题在后面的项目开发中，
我逐个都解决掉了。
轻度使用的问题好说，找一个哥去研究正确的用法然后去优化就行了。
（有时这个优化会涉及几百个文件，所以需要一个 vim 用的溜的哥）
缺少检查也好说，像 flake8/isort/pytest/pylint/yapf/black 我们都尝试使用过，
后面按照项目规模我们开了不同级别的检查，
原则上，项目越大检查越严格。
关于语言与三方库版本的问题，
我每周基本都会保持跟社区的更新，
以人肉 dependency bot 的方式去维护代码。
在解决完这些明显的问题后，
19年我很开心地跟伙伴们感慨过：
“我很有信心说，我们写的这个项目就算放在开源社区也是一流的。”

框架上最终我们还是大规模使用了 Django，
因为 Django 的整套 ORM 实在是对增删改查这样的业务太契合了。
性能上我们后面尝试并最终使用了 gevent，
让整个项目写起来体验一致，
跑起来性能合格。

现在要我实现一个标准的 Python Web 服务的话，我会考虑使用这样的技术组合：

- 使用最新的版本号，比如 Python3.8+/Django3+/Celery4.5+ 等
- 在 CI 中开启一系列标准检查，比如 flake8/isort/pytest/black
- 使用 gnumake/pipenv/drf-yasg 这样的工具链
- 使用 gunicorn+gevent 作为运营环境
- 在语言的性能问题成为了关键问题时，考虑使用 golang 重写关键部分（不过一般此时都要更大程度上更新架构了）


## 平台

过去几年的技术生涯里，
我最主要跟两个平台在打交道：
一个是云平台 (AWS/Aliyun/Azure)，
另一个是业务平台（微信开放平台）。

业务平台没什么特别好说的，
因为我做的整块业务都是基于微信生态的，
所以对开放平台、小程序、OpenID/UnionID、支付回调这么一套非常熟悉。

最早接触的云平台是 AWS(China)，
我觉得云平台最好的一点是运维扁平化。
招人的时候我会跟候选人说，
我们这个职位从网络、业务、数据到部署、监控都要接触。
而能做到这一点的基础，
就是我们“去运维化”地让大家直接去对接云平台
（有些地方可能会简单包一层）。

最早我们用的是 AWS（国服），
相比于国际服，国服用户缺少了一些非常基础的设施
（比如像 ACM/Route53 等）
导致不论是像 zappa 这种跑 serveless 的库，
还是 AWS EKS 这种更高阶的服务能力都是缺失的。
在18年底我司就从 AWS 切换到了 aliyun。
其实整体的架构没有本质上的差别，
感受上阿里云的服务的确好些，
不过按 @lxkaka 的说法也可以叫：
“他们这个系统假如没地方问的话说不过去啊！”

目前我们使用云平台的姿势包括：

- 最基础的开机器、负载均衡、域名一系列
- 数据相关的 MySQL/Redis/Mongo/EMR 一套
- 监控报警日志相关系统
- 全套托管的 K8S

随着对云平台使用的更加深入，
跟云平台强绑定的技术也会越来越多，
比如像日志系统就基本抛弃了 ELK 拥抱了阿里的日志。
但从成本的视角上看，
对工具的使用减少了冗余的运维需求，
一定程度上是解放了工程师的时间与效能。

现在要我从头开始搭建云平台的基建的话，我会考虑这样的实现组合：

- 拆分 VPC 网段，大部分情况分生产、测试、访客三个网段就可以了（并辅以合适的安全组策略）
- 以托管的 K8S 服务为核心搭建业务系统，配上配套基建（云盘、日志、监控等）
- 用 LB/Gateway 约束网络入口、出口，拆分各网段之间流量，尽量减少网络上的损耗
- 选型时优先考虑云原生功能，如 MySQL/ES/MQ 等


## 部署

在大主站时期，
我们的 Python 服务以 supervisor+virtualenv 裸部署在三种机器上：

- Web: nginx+uwsgi+django
- Worker: celery worker
- Cron: celery beat

此时的更新代码是用 fabric 直接连入机器 `git pull + supervisorctl restart` 二连。

这样的问题是无缝发版（蓝绿部署）是需要自己手动实现，
比如我们最早实现了一套基于 AWS LB 的动态添加、摘除节点的逻辑。
这部分逻辑称不上优雅，
也需要自己维护。
而且这么做对机器环境有着强依赖，
在前文的升级 Python 版本中，
我们也需要一并进行系统级别的升级。

不过后来很快我们就进行了全站的 docker 化，
并有过一段短暂的基于 docker network 的无缝发版实现。
此时的部署换成了 `docker pull + docker(compose) restart`。
整条技术链路中我们摘掉了 supervisor/fabric/system 相关的依赖。

伴随着平台从 AWS 迁移到 aliyun，
我们大部分服务也上了 K8S。
部署也从上机器部署升级到了 k8s 相关的部署工具链。

大部分情况项目里用的是手写的 `envsubst + kubectl`，
不过 kubectl 对版本的支持非常有限，
所以很多时候我们也会附带使用 kustomize。
helm chart 而言对业务系统提供了多余的版本控制功能
（我们一般在线上不会同时跑很多个版本，
往往只会保留最新版跟灰度版）。
但 kustomize 也仅在输出部署文件上做的比较好，
在展示部署进度上并没有特别的功能，
而且[很多时候会在项目里漏一大堆的 configmap][km-cm]...
所以到目前，我们不少项目都使用了 kapp 进行部署。

而在构建上，我们从最早的 Jenkins CI 全线迁移到了 GitLab CI。
除了集成单元测试、体验版自动更新、灰度发布这些核心流程以外，
我们还深度尝试了许多 GitLab CI 提供的工具集成。
比如像 kaniko/minio+artifacts/gitlab+sentry 等系列自动集成自动部署的工具基本我们都用到了。

时至今日，我考虑新起的一个 Python 服务会包括以下的技术组合：

- 核心部署流程基于 K8S，生产测试使用相同的配置，以 namespace 区分不同组的业务
- 不采用 helm, 而是使用 kubectl+kustomize+kapp 的方式完成部署
- 以合适的姿势起新三样：
  - 对于 HTTP/RESTful 服务, Web 上使用 gunicorn+django (uwsgi 年久失修了)
  - 对于内部的 gRPC 调用服务，使用内部的 djangrpc 实现 (基于 django，支持一套代码起 http+grpc)
  - 对于异步任务，就是简单的 celery 走起
- 对于以上提到的服务，部署中考虑完整的向前兼容、按流量/用户的灰度、标准的监控日志报警的搭建


## 架构

早期我们的网络拓扑相对简单，
流量的路线是 `外部 ==> aws elb ==> nginx+uwsgi+django(单台机器)`，
我们仅在整条链路上做了少数配置，
比如在 aws elb 上配置 https 的处理，
在机器上做了简单的日志收集。

而现在我们的网络拓扑有多种路径，
以其中相对标准的阿里云上托管的 K8S Web 服务为例：
`外部 ==> ali slb ==> k8s ingress ==> nginx ==> gunicorn+django`.
可以比较发现除了 k8s ingress 层外，
nginx 层也被单独拆分了出来。
这样的网络拓扑我们对其的控制粒度更加精细，
不仅可以在每一层单独处理 IP/流量/日志/行为 等逻辑，
而且每一层也都是可拆卸可更换的。
比如目前我们的集群中，
就有使用到 `nginx-ingress-controller` 的，
也有使用 `kong-ingress-controller` 的。

而在整体的服务架构上，
我们拆分了三层的服务。
顶层是 Web 层，这些服务主要对外部提供服务，走的主要是公网流量的 RESTful 调用；
中间是 Service 层，这些服务主要对内部提供服务，走的主要是内网流量的 RESTful/gRPC 调用
（我们正在使用 gRPC 逐步替换内网 RESTful）；
底层是 Tool 层，包括了一系列我们维护的中间件、工具服务或者是包了一层的云原生服务。

以我现在的认识，在一个中型规模的技术团队（100人规模），我会采取这样的架构技术组合：
- 以网络为边界拆分内外部流量，外部使用 RESTful HTTP 调用，内部使用 gRPC 调用
- 在业务合适的情况下，使用比如类似 Kong 这样的技术作为网关，处理鉴权、灰度、分流等系列逻辑
- 内部服务之间不限制选型（前提是做好人员梯度培养），但要划分清晰的服务边界，进行合适的分层
- 区分不同层服务的级别，以定义好稳定性要求、创新余地与网络拓扑


## 协作

团队协作的核心，就是人跟人的交流。

因为业务线相对较多，我们基本上是以 two pizza team 的粒度来拆分团队的
（two pizza team 的意思就是点外卖时，两份披萨可以让整个团队吃饱）
每个相对较小的团队会负责数个独立的服务，
组内成员互为 backup、互相学习、共同成长。

最早我们的 git 开发流是基于 commit diff 的，
换句话说只要你的改动是正确的，
那基本就可以合并进主干分支了。
——不过我们很快尝到了苦头（这个很快≈三年）
一些老的代码因为当时的产品也没有留下成建制的 PRD，
而且我们公司做的是B端产品，逻辑有时又巨特么合理的绕，
导致后人在 blame history 时，
经常需要去分析这究竟是 bug 还是 feature。

到目前，我们整个团队（强行被）达成了一致，
使用的是“一个 PR 只有一个 Commit 只做一件事情”的基于 rebase 的协作流，
我们这样产出了接近于线性的完美 git 历史。

而另一方面，关于版本控制我们基于 git tag 使用了内部的小机器人来管理。
因为我们不需要考虑旧版本的兼容维护问题，
所以大部分情况我们用的是日期化的格式 (`v2020.07.01`)。
基于 git tag 我们又跟 sentry-release/ticket-system 做了一系列的工具链，
包括自动生成版本之间的 changelog，
自动对每个版本的发布内容进行归类分析等。

整套使用 git rebase 开发，使用 git tag 发布的协作机制让我们获益不少。
而为了达到这样的效果，我们在团队内部达成了这样的约定：

- 认知上，项目以 rebase 为开发基础
  - 没有什么“我不会用 git”的接口，不会可以学。
  - 个人当然可以喜欢 merge，那请在个人项目里用，团队项目大家统一规范
- 行动上，就做到我们设想的那样好
  - 每个 PR 只包含一个 Commit，每个 Commit 只修改一类内容
  - 提了 PR 就求 Code Review, Review 了就留评论，评论改完了就合并，不拖泥带水
- 工具上，我们需要有个哥来解决协作工具完善的问题
  - 我们优化了 Pipeline 的速度，跑完 97% 覆盖率的单元测试+所有检查只要 3 分钟左右
  - 针对线性历史，我们提供了一系列发版、合并、变动检测的机器人助手功能

除了基于 git 的整套开发流，
我们还共同维护着一整个新手村任务（在以前的文章里有讲过），
而且我们推行的 Buddy 制度会让一个有经验的同学完全手把手地带新人
（不过这个具体要看每个人用心的程度了）


## 总结

回过头看，这几年参与的技术讨论、选型、命名、开发、协作、复盘都历历在目。
了解的技术越多，我就越觉得技术世界的广博与好玩。
其实做技术就像玩游戏一样，本质上都是打怪升级穿装备。
本文里讲的，也可能只是我在这世界的一隅，提笔能想起来的一些只言碎语。

但假如我要把整篇文章都删掉，
只能留下一句话。
那我会毫不犹豫地留下这句话：

**不会可以学**

![u-can][u-can]

（未完待续）


[tree]: /backend-skill-tree
[py3]: /py2-to-py3
[wangyin]: https://www.yinwang.org/
[km-cm]: https://github.com/kubernetes-sigs/kustomize/issues/1806
[u-can]: /assets/u_can_learn.jpg