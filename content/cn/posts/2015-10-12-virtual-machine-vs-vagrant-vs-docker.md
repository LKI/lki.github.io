---
title:     "Virtual Machine, Vagrant, Docker的区别"
date:      2015-10-12 12:49:55
aliases:
  - /virtual-machine-vs-vagrant-vs-docker
---

Virtualization——虚拟化技术一直是计算机世界里面很重要的东西。
一般程序员听到这个词首先浮现出的就是Windows下面开着装着Linux系统的VMware。
而这个“装着Linux系统的VMware”就是我们口中的虚拟机（Virtual Machine）

<!--more-->

虚拟机的主要好处是可以创建一个与主机操作系统不同的开发环境
（比如说一般的办公室都是Windows系统电脑）

但是开发的便利也会导致初始化一个这样的环境比较麻烦
而且当项目进行到一定程度，对环境本身一些变化有依赖的时候
从零开始创建虚拟机的开发环境会很繁琐
Vagrant就是一种用来解决这种繁琐的工具


## Vagrant
根据[官方的说法][why-vagrant]

> Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team

Vagrant本身不做虚拟机的工作，而是允许用户用VMware|VirtualBox|AWS来启动虚拟机镜像，他们管这叫Provider
当然了，镜像在Vagrant这里叫Box，而且很多公司已经做好了初始化的Box[在这里][hashicorp-box]可以直接用
Vagrant还提供了对Box的初始化脚本（Provisioning），这些初始化脚本可以用更多的脚本工具来完成对Box的配置

所以其实相比于传统的虚拟机，Vagrant是站在巨人的肩膀上，完成了自动化。


## Docker
Docker项目的目标是实现轻量级的虚拟化方案，它和Virtual Machine最大的不同是Docker容器共享操作系统的内核
![vm][virtual-machine]
![docker][docker-engine]

所以Docker和传统虚拟机的对比是明显的：

| 特性       | Docker   | Virtual Machine   |
|------------|----------|-------------------|
| 启动       | 秒级     | 分钟级            |
| 大小       | 一般为MB | 一般为GB          |
| 性能       | 近原生   | 弱于原生          |
| 单机支持量 | 上千个   | 一般几十个        |
| 内核       | 共享     | 独立              |


## Vagrant vs Docker
讲道理的话，这两个不应该放在一起比较， 这两者的虚拟化级别并不是一个量级上的
而且这两者并不矛盾，假如你需要在Windows系统上搭载数个特定发行版的Linux系统，完全可以先用Vagrant + Virtual Machine再嵌数个Docker

硬要比较的话，假如你需要运行跨平台的虚拟，那就用Vagrant，*否则*，用Docker

最后再来张表对比一下吧：

| 特性     | Virtual Machine | Vagrant      | Docker       |
|----------|-----------------|--------------|--------------|
| 虚拟化   | 完全虚拟化      | 无           | 系统虚拟化   |
| 镜像管理 | 无              | 有，一般为GB | 有，一般为MB |
| 性能     | 弱于原生系统    | 弱于原生系统 | 接近原生系统 |
| 内核     | 独立            | 独立         | 共享         |


## 参考资料
1. [《Docker —— 从入门到实践》][docker-the-book]
2. [Why Vagrant][why-vagrant]
3. [Docker不是虚拟机][docker-by-shell909090]
4. [Shoud I use vagrant or docker][so-vagrant-or-docker]

[why-vagrant]:             https://docs.vagrantup.com/v2/why-vagrant/index.html
[hashicorp-box]:           https://atlas.hashicorp.com/boxes/search
[virtual-machine]:         http://dockerpool.com/static/books/docker_practice/_images/virtualization.png
[docker-engine]:           http://dockerpool.com/static/books/docker_practice/_images/docker.png
[docker-the-book]:         http://dockerpool.com/static/books/docker_practice/index.html
[docker-by-shell909090]:   https://github.com/shell909090/slides/blob/master/md/docker.md
[so-vagrant-or-docker]:    http://stackoverflow.com/questions/16647069/should-i-use-vagrant-or-docker-io-for-creating-an-isolated-environment
