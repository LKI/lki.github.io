---
title:     "数据仓库解决方案 RedShift 入坑指南"
date:      "2017-09-08 22:59:08"
aliases:
  - /redshift-as-data-warehouse
---

最近工程师小谢遇到了一个难题，
就是手头上有千万级别的数据，
但是没有一个快糙猛的解决方案。

<!--more-->

## 提出问题

> 想直接看 RedShift 相关的，
> 请跳过前两节瞎扯淡。
> 直接到第三节观看。

不像少部分优秀的可以活在彼岸的人，
可以醉心于写出完美的数据库，
在须臾间学会所有的程序语言；
世上大部分程序员都活在此岸，
他们要解决一个个特定的业务问题。

工程师小谢就很烦恼，
[ 上次产品经理小刘提了个老酷炫的IDEA： ][cash-cow]
“现金牛”。
观众们很过瘾，
但作为要实现功能的人，
小谢有点郁闷。

具体来说，难点在下面几个：

1. 数据量很大。
公司是做菜品相关的，每天记录的菜品数据非常多。
而且随着公司业务发展，菜品增速增长率也很高。
（也就是“指数级上升”）

2. 时间比较紧。
不像学校里的大作业，可以有一整个学期来实现到交付。
真正的需求是事情要尽可能早的完成，即使一开始不一定是完美的，
但是会更早得到外部反馈，正面/负面的评价有助于大家调整前进方向。

3. 质量有要求。
基于“现金牛”的这个需求交付完成以后，又会有新的需求降临到小谢的肩上。
所以这个此时的解决方案，也要解决彼时的问题。
随着业务/数据量的增大，短时间内（比如说一年），解决方案得稳定靠谱。
长时间内（比如说三年），解决方案要能拓展，至少是便于重构的。


## 解决方案

上面的几个现世问题，
其实跟万千现世问题一样，
都是一个问题：`如何在有限的资源下，完成既定的目标？`
解决方案也都是通用的：`转换资源、付出时间、更换目标`。

当然，小谢明白，脱离实际例子的方法论都没有意义。
所以小谢打算整一个数据仓库 (Data Warehouse)

数据仓库，跟数据库 (DataBase) 很像，
就像军械库是放军械的地方，
车库是放车的地方，
数据仓库/数据库就是放数据的地方。
~~多了个仓是因为还放仓鼠~~

二者不同之处详细来说，
就是因为要解决的问题不一样：
数据库是要给业务提供基础保证，
数据仓库则是给面向决策的数据分析提供便利；
所以二者的设计思想也不一样：
数据库遵守范式设计，强调数据约束、一致性，读写操作都有涉及，
数据仓库则是存储大量冗余数据、统计数据，对读的优化更多。

**举个栗子**就是今天中午小谢去吃了四斤烤鱼（真能吃），
“四斤烤鱼”的数据存在了数据库里，是用来买单算钱的。
但“今天中午，四斤，烤鱼”这样的统计数据就存在了数据仓库里，
以用来之后的统计分析。

业界很多的数据仓库都是基于 `Hadoop/Spark/Storm` 的一套 `Java` 系技术栈的。
比如拼多多，用的就是 `Hadoop/Hive/HBase/Kafka` 一套技术栈。
比如小红书，用的也是 `Hadoop/Hive/Spark/Kafka` 一套技术栈。

但是问题来了：
这些小谢都不懂啊，很尴尬。
不过还好，小谢有钱，
他可以去招几个懂的。
很可惜，招聘是个玄学问题，
他看上的看不上他，
看上他的他看不上。

于是小谢想来想去，
也只能自己动手，
最终选择了：


## RedShift, 亚马逊云服务全家桶 之 数据仓库 管理助手


### 特点

作为一种数据仓库的解决方案，
RedShift 有几个特点：

* 省事，假如你也用了 AWS 的其它服务。
自带监控，需要定制化的话还可以跟 AWS CloudWatch 结合；
往里面插入数据推荐用的 `COPY` 命令是和 AWS S3 联动的；
高可用、拓展性、备份等都是 AWS 保证的。

* 提供全套 `PostgreSQL` 语法。
基本上兼容 `PostgreSQL` 的地方，换一下 `DBDriver` 就可以无痛使用了。
但是 RedShift 也只提供了一套 `SQL` 的标准，
假如要做 `SQL` 之外的（比如文件）数据存放，
就很吃力了。~~by design. wontfix~~

* 贵，相对而言。
定价大概最便宜的实例类型 (dc1.large, 15GB Mem, 0.16TB SSD) 是一年一万多人民币，
不算人力价格的话，比自建数据仓库肯定要贵。
不过算上人力价格的话……就另说了。


### 部署

部署使用 RedShift 的主要步骤如下：

1. 先别急着创建实例，先按照 AWS 的教程走一遍，
会对 COPY/Encoding/Cluster 有初步了解。
~~不喜欢读英文文档的同学，可以右上角切换成中文~~

2. 创建合适的 AWS RedShift 实例。
恭喜你完成了_从无到有搭建数据仓库_这个成就。

3. 对接业务，比如选择合适的 Driver。
我们用的是 django, 直接用 `psycopg2` 就可以连接了。
然后就是ETL、缓存、图表等通用的业务操作了。


### 心得

用了 RedShift 一阵子，
有几点学到的地方：

* **SQL 语句不是直接执行，而是编译后分发执行**。

不论我们执行任何语句，即使是 `INSERT INTO` 这种单条操作，
RedShift 都要编译后执行，耗时 500ms 起步_所以要用COPY来做数据导入_。
又比如我们部署了四个 RedShift 节点，那在
`SELECT * FROM orders WHERE business_id = 100` 编译完成以后，
RedShift 会把操作根据建表时选定的分区键 `DISTKEY` 把命令分发到各个节点操作。
所以合理的表结构也是查询速度的关键_通用的~~废话~~真理_。


* **插入数据用 COPY 命令；更新数据 COPY 到临时表以后，用 DELETE USING + INSERT INTO 来更新数据**

因为每条 SQL 都要编译，所以尽量做批量操作，单条操作是非常愚蠢的。
（就像我们最开始那么愚蠢一样=\_=）
RedShift COPY 命令支持 GZIP, JSON, From S3 等多种操作，
大部分情况下，加载速度和存储效率都会比普通的 INSERT 要好。
同理，更新单条数据采用了先删再增的方式。


* **定时维护数据仓库**

RedShift 不会自动回收 DELETE/UPDATE 所释放的空间，
需要用户手动运行 `VACUUM` 命令来清理表。
`VACUUM` 本身也是IO密集型操作，
所以最好是在空闲的时间（比如早上四点）定时跑。


* **注意表的限制**

在 RedShift 里，
`unique / primary key / foreign key`都是展示信息，
没有实质约束力。

还有 RedShift.varchar 存储的是单字节字符，
像 MySQL 的 `utf8` 默认是三字节字符，
假如用了 `utf8mb4` 就是四字节字符。
所以 MySQL 里的 varchar(50) 换算到 RedShift 里就应该是 varchar(200)。
_被Emoji坑了的人留_


## 总结

总的来说，
RedShift 的最大的好处在于用钱换取生产力，
简单易用，是 AWS 全家桶用户对数据仓库的一种解决方案。
具体用法多加注意，也没有什么特别之处。

不过最近好像是给亚马逊交了不少钱，
他们都派工程师上门免费 support 了。

小谢心想。


## 课外阅读

* [AWS - RedShift 官方教程 - http://docs.aws.amazon.com/zh_cn/redshift/latest/dg/tutorial-tuning-tables.html][aws-redshift]

* [酷壳 - 由12306.CN谈谈网站性能技术 - https://coolshell.cn/articles/6470.html][coolshell-12306]

* [维基百科 - 数据仓库 - https://en.wikipedia.org/wiki/Data_warehouse][wiki-dw]

* [全面了解mysql中utf8和utf8mb4的区别 - https://my.oschina.net/xsh1208/blog/1052781][utf8mb4]

* [西乔 - 历史悲剧 - http://blog.xiqiao.info/2013/01/14/1366][utf8-enough]


[cash-cow]: /what-is-cash-cow
[aws-redshift]: http://docs.aws.amazon.com/zh_cn/redshift/latest/dg/tutorial-tuning-tables.html
[coolshell-12306]: https://coolshell.cn/articles/6470.html
[wiki-dw]: https://en.wikipedia.org/wiki/Data_warehouse
[utf8mb4]: https://my.oschina.net/xsh1208/blog/1052781
[utf8-enough]: http://blog.xiqiao.info/2013/01/14/1366

