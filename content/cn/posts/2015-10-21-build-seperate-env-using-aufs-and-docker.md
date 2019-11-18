---
title:     "利用AUFS和Docker搭建多个私有开发环境"
date:      2015-10-21 14:55:24
aliases:
  - /build-seperate-env-using-aufs-and-docker
---

文章的开头先提个问题：
我们平常的工作中，一般都是怎样让每个人都拿到独立开发环境的呢？

<!--more-->

## 八仙过海

比如最常见的做法：每人都有自己的电脑，爱怎么弄怎么弄，同步代码就用Git之类的。
但是这样初始化的过程很慢，要装各种软件各种配置。

于是也有的是建一个中心服务器，大家用Putty这类软件SSH上去，每个人都有自己的账号。
但是这样环境不独立，而且权限控制很麻烦（毕竟每个人都想sudo）

后来就直接分发虚拟机镜像了，每个人拿到一个10G的镜像文件，
直接Load一下，环境就起来了。
但是这样每次修改环境就要更新近10G…

反正就是八仙过海，各有神通了。
利用[AUFS][aufs]和[Docker][docker-intro]也可以做到给每个人独立开发环境。


## AUFS

根据Google:

> AuFS stands for Another Union File System. AuFS started as an implementation of UnionFS Union File System. An union filesystem takes an existing filesystem and transparently overlays it on a newer filesystem. It allows files and directories of separate filesystem to co-exist under a single roof.May 8, 2013

假设我们有一个目录如下：

```
$ tree
.
└── public
    ├── database
    │   ├── dbfile1
    │   └── dbfile2
    └── src
        ├── helloworld.lisp
        └── sudoku.lisp
```

我们希望以public目录为基础，给每个人创建一个private环境
于是我们跑几条命令：

```
$ mkdir change private
$ mount -t aufs -o dirs=./change:./public none ./private
$ tree
.
├── change
├── private
│   ├── database
│   │   ├── dbfile1
│   │   └── dbfile2
│   └── src
│       ├── helloworld.lisp
│       └── sudoku.lisp
└── public
    ├── database
    │   ├── dbfile1
    │   └── dbfile2
    └── src
        ├── helloworld.lisp
        └── sudoku.lisp
```

mount命令中，-t指定了type是aufs，-o是option
把change命令以读写权限，public目录以只读权限mount到了private里面

假设我们在private命令中新增，修改了一个文件：

```
$ cd private/
$ touch newfile
$ echo "Changes" > src/sudoku.lisp
$ cd ..
$ tree
.
├── change
│   ├── newfile
│   └── src
│       └── sudoku.lisp
├── private
│   ├── database
│   │   ├── dbfile1
│   │   └── dbfile2
│   ├── newfile
│   └── src
│       ├── helloworld.lisp
│       └── sudoku.lisp
└── public
    ├── database
    │   ├── dbfile1
    │   └── dbfile2
    └── src
        ├── helloworld.lisp
        └── sudoku.lisp
```

可以看到我们在private环境中所做的所有改动都在change中发生了！

这就相当于图层（Layer）的叠加，我们往只读的public层上叠加了一层可写的change层。
*不过对于删除文件的情况要进行额外的检测*


## 与Docker的叠加

有了上例中的mount，那和Docker就很好叠加了
利用[Docker的Volume][docker-volume]：

```
docker run -ti -v /tmp/docker/private:/work ubuntu /bin/bash
```

这样就可以把private目录作为volume映射到docker container里面的/work目录了。
剩下的就是[Get good use of docker images][docker-images]了~

[aufs]:            https://coolshell.cn/articles/17061.html
[docker-images]:   https://docs.docker.com/userguide/dockerimages/
[docker-intro]:    /virtual-machine-vs-vagrant-vs-docker
[docker-volume]:   https://docs.docker.com/userguide/dockervolumes/
