---
title: "软件工程实践之 Git 开发流"
date: 2020-01-14T21:39:31+08:00
aliases:
  - /software-engineering-git-workflow
---

软件工程实践系列文章，
会着重讲述实际的工程项目中是如何协作开发软件的。
本文主要介绍如何使用 Git 来支撑整个开发流。

<!--more-->


## outline

本文包括以下内容：

- operation: 团队保持一致的操作
  - commit: 提交原子性的代码
  - history: 保持线性干净的历史
  - release: 遵循科学的发布规范
- tool chain: 搭建自洽的工具链
  - gitlab/github: 使用现代的开发平台
  - ci/cd: 让系统把控代码质量
  - sentry/k8s: 用版本连接整个系统
- conclusion


## operation: 团队保持一致的操作

Git 提供了一套自由而又强大的 api,
我们可以通过它以各种姿势来完成代码协作。
但俗话说得好，
选择越多人越懵。~~并没有这句俗话~~
所以在团队协作时，
保持一致的操作是很重要的。

### commit: 提交原子性的代码

Git 的最小单元就是一个 commit。
我们团队遵循的最佳规范是保持每个 commit 的原子性：
**一个 commit 只做一件事情。**

比如一个关于缺陷修复的 commit 可以非常简单，
它只有两行：
一行修复了代码逻辑，
一行加了单元测试。

另一个关于重构的 commit 可能会修改 200+ 个文件，
但也因为只做了一件事情，
所以不会给 code review 带来很大负担。

![large-commit][large-commit]

原子性的 commit 不仅能很好地支持 revert/cherry-pick/bisect 等一系列 Git 的原生命令，
而且在保持线性干净的历史这一点上，
也是至关重要的。

### history: 保持线性干净的历史

随着时间的推移，
Git 的每一个 commit 会成长为一个枝叶繁茂的历史树。
基于 [fast forward][git-ff] 的合并能让 Git 的历史树保持干净与线性。

![git-log-tree][git-log-tree]

> 这是我们项目 git log 翻到四个月以前的一张截图，
> 可以看到历史依旧是线性干净的。

线性的历史意味着在每个人提交代码前需要 rebase。
一个例外是在发布分支(master)上提交 hotfix 后，
合并回开发分支(dev)需要视情况关闭 fast forward (--no-ff)。
而且要求大家 rebase 则对团队成员的 Git 水平以及合并习惯提出了一定要求。

干净的历史则需要大家都严格遵循 commit 的原子性，
以及要按照标准撰写 commit message。
关于 commit message 的撰写，
阮老师有一篇[《commit message 编写指南》][ryf-commit]讲的够好。
我们也可以在 git hook 中开启对 commit message 的校验，
以确保格式的整洁统一。

通过**fast forward merge + 统一的 commit message**，
我们就能维护一个不断成长、但又干净线性的历史树，
能最大程度地给各种 git 的版本操作提供便利。

### release: 遵循科学的发布规范

**我们使用 git tag 来作为版本发布的标志。**

![git-log-tree][git-log-tree]

因为我们的项目是一个 web 服务端项目，
我们同一时刻基本上只需要维护最新的版本，
所以我们使用了日期型的版本号数字(`v2019.9.9`)。
在大部分开源工具里，
都会使用[语义化的版本号(semver: `v2.0.0`)][semver]。

基于原子的 commit、线性的历史，
在每次版本发布时，
我们都会自动化地生成 tag/changelog。

![gitlab-release][gitlab-release]

一个遵循了良好规范的 tag 能最大程度地利用工具链的集成功能，
给开发、测试、上线、监控提供完备的功能。


## tool chain: 搭建自洽的工具链

在注重团队协作、开发流程、发布质量的软件工程中，
会有一系列开发工具围绕 Git 的代码历史树，
提供了自洽的工具链。

### gitlab/github: 使用现代的开发平台

我们使用 `GitLab` 来管理代码项目，
其中重度使用的是 `Merge Request` 来作为 code review 的载体。
~~不过我们跟着 GitHub 的设定，管它叫 PR (Pull Request)~~

为了维持 PR 的原子性，
大部分情况我们遵循单个 commit 对应单个 PR，
这样既方便 review 也方便分支管理。
不过这样的开发流会产生非常多的 PR，
需要团队开发者都保持在一个更积极的开发状态下。

现代的开发平台还会集成更多工作流上的功能，
我们还重度使用的是把 GitLab Runner 作为我们 ci/cd 的工具载体。

### ci/cd: 让系统把控代码质量

![gitlab-pr][gitlab-pr]

> 在提完 PR 以后，
> 系统会自动化地启用一系列的 Python/Django 检查。

![gitlab-pipeline][gitlab-pipeline]

> 通过 git tag 发布版本后，
> 系统会自动化地跑构建、灰度等一系列部署任务。

除了 GitLab Runner,
其它像 Jenkins/Travis CI/GitHub Actions 也可以类似的 ci/cd 功能。

集成 ci/cd 能让整个开发流变得更加柔顺，
让每一个改动的影响都可以即时地通过数据展示出来。
ci/cd 加上 code review，
能最大程度地让代码库保持活性，
长远地能避免“往屎山上堆屎”的发生。

前面提到我们的 PR/release 频率都会比较高，
所以 ci/cd 也需要在更短的时间内跑完，
以避免龟速检测导致的各种心态爆炸、skip ci。
目前我们项目平均能在 5min 内跑完包括 96% 覆盖率的单元测试的多项检查，
也能在 5min 内跑完从构建、灰度到全量的整个发布流程。

整个 ci/cd 的流程其实也跟写接口这样的业务类似，
是需要不断迭代、不断优化、不断适应更好的开发流的。

### sentry/k8s: 用版本连接整个系统

在开发的流程走完以后，
软件工程还关心发布的流程、质量把控的流程。

我们绑定了 docker image tag 与 git tag，
最终发布部署在 k8s 上的每一个版本也跟 git tag 的版本强关联。
这样的设定之下，
比如像 `kubectl rollout` 的一系列操作就会跟 Git 历史树关联上。

![sentry-release][sentry-release]
> 我们也使用了 sentry 来检测管理代码的线上问题。

所有的外部系统都使用着统一的 tag version 来关联问题，
这样我们就给 debug, 历史溯源，分锅都提供了统一的工程语言。


## conclusion

基于 Git 的开发流不是一个一成不变的框架，
它会因为项目特质、团队成员习惯、工具链的不一样而有着不同的表现形式。

我们团队在软件工程的实践中，
保持并维护着这么一套开发标准：

- 保持 commit 的原子性，一个 commit 只做一件事情。
- 遵循编写 commit message 的标准，并且会在 code review 时关注。
- 统一团队成员的操作习惯，使用 rebase + fast forward merge。
- 自动化地生成 git tag 以及 changelog，并基于此做代码发布。
- 搭建快速全面的 ci/cd 流程，自动化地做掉所有代码检查。
- 使开发流与社区最佳实践一致，了解并利用好各类工具的集成功能。

这套开发流也给我们提出了这些挑战：

- 要对 Git 有一定了解，包括历史树操作等进阶知识。
- 除了编码时，在协作时也要保持积极的态度，以及协作上的高标准。
- 最重要的，对最佳实践的追求，以及不懂就学的态度。

这样的 Git 开发流，最终带来了这些效果：

- 线性的历史让 debug、追溯变更、了解项目发展过程都变得非常友好。
- 项目一方面能保持快速活跃的开发效率，另一方面能保证长期维护的质量。
- 最佳实践的讨论以及迭代，让团队内部一直维持着很好的工程师文化。

软件工程的实践中，
好的 Git 开发流是不可或缺的一部分。
以后我们再以不同的视角来分享更多软件工程的实践。

（完）


[large-commit]: /assets/pics/gitlab_large_commit.jpg
[git-ff]: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
[git-log-tree]: /assets/pics/git_log_tree.jpg
[ryf-commit]: https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html
[semver]: https://semver.org/lang/zh-CN/
[gitlab-release]: /assets/pics/gitlab_release.jpg
[gitlab-pr]: /assets/pics/gitlab_pr.jpg
[gitlab-pipeline]: /assets/pics/gitlab_pipeline.jpg
[sentry-release]: /assets/pics/sentry_release.jpg
