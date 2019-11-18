---
layout: post
title: Git的理念
date: '2018-02-10 16:01:31'
aliases:
  - /philosophy-of-git
comments:
  - author:
      type: github
      displayName: LinJinghua
      url: 'https://github.com/LinJinghua'
      picture: 'https://avatars0.githubusercontent.com/u/30121146?v=4&s=73'
    content: >-
      &#x5BF9;&grave;git&grave;&#x53EA;&#x662F;&#x6A21;&#x7CCA;&#x4E86;&#x89E3;&#xFF0C;&#x5982;&#x6709;&#x4E0D;&#x5BF9;&#x8BF7;&#x6307;&#x6B63;:P&#x3002;
       - &#x5173;&#x4E8E;Line Diff: &#x5B58;&#x5728;50%&#x4EE5;&#x4E0A;(&#x5305;&#x62EC;50%)&#x884C;&#x76F8;&#x4F3C;
       - &#x5173;&#x4E8E;Commit: &#x5229;&#x7528;&grave;filter-branch&grave;&#x4FEE;&#x6539;&grave;GIT_AUTHOR_NAME&grave;&#xFF0C;GitHub&#x4E0A;&#x80FD;&#x770B;&#x51FA;&#x6765;Committer(Committer&#x4E0E;Author&#x4E0D;&#x540C;&#x65F6;github&#x7684;commit&#x5386;&#x53F2;&#x4F1A;&#x663E;&#x793A;&#x4E24;&#x8005;)&#xFF0C;git&#x5B58;&#x50A8;&#x7740;&grave;GIT_COMMITTER_NAME&grave;&#x548C;&grave;GIT_COMMITTER_EMAIL&grave;&#x4FE1;&#x606F;&#x3002;
      - &#x5173;&#x4E8E;Branch:
      &#x5220;&#x9664;&#x8FDC;&#x7A0B;&#x5206;&#x652F;&#x5229;&#x7528;&grave;git
      push origin-name
      :branch-name&grave;&#xFF0C;&#x53EF;&#x4EE5;(&#x4E0D;&#x662F;&#x5F88;&#x4E86;&#x89E3;stash&#x673A;&#x5236;&#xFF0C;&#x4F46;&#x731C;&#x60F3;branch,commit,
      stash&#x5E94;&#x8BE5;&#x90FD;&#x662F;&#x4E00;&#x4E2A;&#x6307;&#x9488;)&#x3002;

      - &#x5173;&#x4E8E;Repository:
      &#x4F1A;&#x3002;&#x4F46;&#x53EA;&#x662F;&#x5220;&#x9664;&#x4E00;&#x4E2A;&#x6807;&#x8BB0;&#x5206;&#x652F;&#x7684;&#x6587;&#x4EF6;&#xFF0C;&#x5177;&#x4F53;&#x5BF9;&#x8C61;&#x5220;&#x9664;&#x5E94;&#x8BE5;&#x662F;&grave;git-gc&grave;&#x56DE;&#x6536;?

      - &#x5173;&#x4E8E;Remote:
      &#x4E0D;&#x653E;&#x7F6E;&#x7BA1;&#x7406;&#x6587;&#x4EF6;&#xFF0C;&#x5373;&#x6CA1;&#x6709;&grave;work
      tree&grave;&#x3002;&#x4E00;&#x822C;&#x5728;&#x670D;&#x52A1;&#x5668;&#x4E0A;&#x90E8;&#x7F72;
      Git &#x4ED3;&#x5E93;&#x65F6;&#x4F7F;&#x7528;&#x3002;
    date: 2018-08-08T15:18:57.977Z

---

本文尝试介绍一下Git的过人之处。
目标读者是想了解Git，
或者对软件设计有兴趣的人。

<!--more-->

Git作为一个极其灵活的工具，
从修改单机游戏数据文件的版本管理，
到多人协作一起堆屎的协作开发，
使用起来都是十分趁手。

那么Git灵活的奥秘在哪呢？
大概是因为Git设计正交、实现扎实吧。


## 总览

Git里面的术语/命令很多，
但是它们可以归并成几个大类，
每个大类的概念都是正交的，
也就是说交叉概念很少，
不会有模糊的概念定义。
基于这样的设计，
Git与之对应地实现了一套扎实的命令系统。

> Git里的概念有些难以准确翻译，
> 本文涉及概念词的地方尽量用术语表达 。

比如经常用到的概念会有这些：

* Line Diff
* Commit
* Branch
* Repository
* Remote


## Line Diff

Git实现版本控制的方法是根据Line Diff，
推算出每个Commit具体改了哪些东西，
然后用多个Commit（实则是多份Line Diff）构建出所有历史。

这个基于Line Diff的先天设计决定了Git的一些特性：

1. 可以存储所有历史。
   我们常听到“Git是一个分布式的版本控制系统”，
   这个指的就是Git不需要中心化的服务器，
   你就可以做完所有操作。
   因为本地存着所有的Line Diff，
   所以“查看昨天被改过的文件名列表”这个操作完全可以离线完成。

2. 对二进制文件不友善。
   二进制文件是没法强行比Line Diff的。
   所以假如用Git管理二进制文件，
   Git只会显示一个`Binary File Differ`。
   再把上面一条“存储所有历史”给叠加上，
   就会出现今天提交了一个200M的文件，
   明天后天我都修改覆盖了这个文件，
   最后整个目录就有600M大了…
   （也就是说一般不用Git来管理二进制大文件）

3. 能检测文件重命名。
   假如在一个Commit中，
   从Line Diff的视角看，
   删除的文件和增加的文件相似度很高，
   Git就会判定这是一个重命名的操作。


## Commit

Line Diff组成了Commit，
Commit是大部分Git操作的最小单位。
这个词既是动词，也是名词。

一个Commit包含了多种信息：

- SHA hash：是根据line diff + 精确到秒的时间戳生成的一串唯一标识符
- Author：写Line Diff的人
- Committer：一个隐藏的属性，代表Commit的人
- Date：包括AuthorDate和CommitDate
- Message：Commit文本描述，Git会取Message第一行作为Subject，所以一般会遵循[一定规范][message]
- Line Diffs：改动了哪些内容

这里还可以说的概念包括RootCommit、MergeCommit，
不过它们特殊之处不影响实际使用，
所以跳过它们，继续往下说。


## Branch

多个Commit会组成一个Branch，
最初的Branch默认叫master（主干分支）。

Branch和Commit在很多命令里都是可以作为等价的操作对象的。
举个例子：

小成写了一天代码，
他在wechat这个分支上commit了很多次，
快下班了，小成想回顾一下今天的改动。
假设他的log长这样子：

```
> git log --oneline --graph
* f01c8d1 (HEAD -> wechat) refactor: improve project layout
* 2f9c867 feat: add rest api to create card
* 5d5242b feat: custom wechat card background
* 873e6ca fix: wechat card slow query
* 0dd06a9 fix: 500 when user unsubscribe
* fb91f98 (origin/master, master) feat: implement wechat card
* 176b4f0 feat: implement membership level
* 2727226 migration: add Settings.enable_level
...
```

那么以下命令是完全等价的：

```
# 查看从master到wechat的diff
> git diff master..wechat

# 查看从master到当前的diff（HEAD代表当前位置，也就是wechat分支）
> git diff master..HEAD

# 查看从master到当前的diff（HEAD是默认值，可省略）
> git diff master

# 查看master的commit到当前的diff
> git diff fb91f98

# 查看五个Commit以前倒当前的diff（master分支在五个Commit以前）
> git diff HEAD~5
```

所以也可以说“Branch是特殊的Commit”。
理解了这一点以后，
再去看大部分的Git命令，
发现它们都是`git <operation> <range> -- <files>...`这样的形式。

比如查看今天发布哪些内容就是`git diff master..release`，
把某个文件回滚到200个Commit以前就是`git checkout HEAD~200 -- some/path/some/file.txt`，
查看单个文件的改动历史就是`git log -- some/path/some/file.txt`


## Repository

Repository包含了所有的操作历史。
`git init`命令可以初始化一个Repository。

一个Git Repository结构可能是这样的：

```
- .git/
  - hooks/
  - objects/
  - refs/
  - HEAD
  - config
- ForgiveDB/
- README.md
- requirements.txt
```

这里的`.git`目录就存储着上面讲的Line Diff、Commit、Branch的所有历史，
就像上面二进制大文件的那个例子，
这里可能存了几百M的文件历史。


## Remote

Remote就是放在别的地方的Repository。
同一个Repository可以添加多个Remote。

除了`push/pull/fetch`这些基本操作以外，
关于Remote还有一个很骚的设定：
Git支持本地Remote。

比如样例的命令如下：

```
# 假设在服务器上的 /home/lirian/chinese-calendar 路径下有一个 Repository
> cd /home/lirian

# 把它 clone 到某一个地方
> git clone chinese-calendar /opt/git/repo/chinese-calendar --bare

# 同个服务器上的另一个用户就可以 clone 这个 Repository
> cd /home/ldsink && git clone file:///opt/git/repo/chinese-calendar && git remote -v
origin       file:///opt/git/repo/chinese-calendar (fetch)
origin       file:///opt/git/repo/chinese-calendar (push)
```

这样的设计之下，
Remote/Repository是完全分离的，
不会因为断网就修改不了历史。
我们甚至可以把Remote当成一种特殊的Branch，
比如`fork - pull request`就是这种模式的一种应用。


## 尾言

文中讲到的不少例子有一些浅尝辄止，
读者有兴趣的话可以尝试思考实现一下这几个拓展问题：

* 关于Line Diff：改动的两个文件相似度多高，Git才会识别为重命名呢？
* 关于Commit：如何修改Commit的Author？GitHub上能看出来Committer么？
* 关于Branch：如何删除远程分支？`git stash`产生的Commit可以像Branch一样操作么？
* 关于Repository：删除分支以后，Git目录会变小吗？
* 关于Remote：文中用到的`--bare`参数是什么意思？

Git的设计理念中还有很强大的一部分是它关于历史（History）的管理，
那又是一个值得细说的话题。

总的来说，笔者眼中Git是一个科学且强大的工具。
Git优秀的原因在于它：

* 正交的设计：术语定义清晰，重叠概念少，表现张力强大。
* 扎实的实现：二级术语丰富，命令参数完善，贴合实际应用场景。

（完）

[message]: http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html

