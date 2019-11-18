---
layout: post
title: Python项目自动化部署之一：举个栗子
date: '2017-11-23 16:49:57'
aliases:
  - /python-deployment-automation-one-sample
comments:
  - author:
      type: github
      displayName: messense
      url: 'https://github.com/messense'
      picture: 'https://avatars0.githubusercontent.com/u/1556054?v=4&s=73'
    content: >-
      &#x89E6;&#x53D1; build
      &#x8FD8;&#x662F;&#x624B;&#x52A8;&#x7684;&#x5440;&#xFF0C;&#x6211;&#x53F8;&#x7684;
      in-house &#x89E3;&#x51B3;&#x65B9;&#x6848;&#xFF1A;


      CI &amp; CD: https://github.com/bosondata/badwolf


      push
      &#x4EE3;&#x7801;&#x5230;&#x4F1A;&#x90E8;&#x7F72;&#x7684;&#x5206;&#x652F;/tag
      &#x89E6;&#x53D1; CI
      &#x6D4B;&#x8BD5;&#xFF0C;&#x6D4B;&#x8BD5;&#x6210;&#x529F;&#x53EF;&#x80FD;&#x4F1A;&#x5728;
      CI
      &#x4E2D;&#x7EE7;&#x7EED;&#x8FDB;&#x884C;&#x4E00;&#x90E8;&#x5206;&#x6784;&#x5EFA;&#xFF08;&#x6BD4;&#x5982;&#x6253;&#x5305;
      Python package&#x3001;webpack
      &#x6784;&#x5EFA;&#x524D;&#x7AEF;&#x4EE3;&#x7801;&#x7B49;&#xFF09;&#xFF0C;&#x5B8C;&#x6210;&#x540E;&#x81EA;&#x52A8;&#x89E6;&#x53D1;&#x90E8;&#x7F72;&#xFF0C;&#x6BD4;&#x5982;
      upload package &#x5230; pypi&#x3001;&#x89E6;&#x53D1; saltstack
      &#x90E8;&#x7F72;&#x5230;&#x5BF9;&#x5E94;&#x7684;&#x670D;&#x52A1;&#x5668;&#x4E0A;&#x5E76;
      reload &#x670D;&#x52A1;&#x3002;


      supervisord
      &#x611F;&#x89C9;&#x5F88;&#x96BE;&#x7528;&#xFF0C;&#x6211;&#x4EEC;&#x4E3B;&#x8981;&#x7684;&#x670D;&#x52A1;&#x90FD;&#x662F;&#x7528;
      systemd &#x6765;&#x7BA1;&#x7406;&#x3002;
    date: 2017-11-23T09:40:50.948Z
  - author:
      type: github
      displayName: LKI
      url: 'https://github.com/LKI'
      picture: 'https://avatars0.githubusercontent.com/u/3286092?v=4&s=73'
    content: >-
      @messense
      &#x624B;&#x52A8;&#x7684;&#xFF0C;&#x89E6;&#x53D1;&#x7684;CI&#x53EA;&#x4F1A;&#x8DD1;&#x4EE3;&#x7801;&#x98CE;&#x683C;/UT&#x4E00;&#x7CFB;&#x5217;


      badwolf&#x5B66;&#x4E60;&#x4E86;&#xFF0C;&#x4E4B;&#x540E;&#x53BB;&#x7814;&#x7A76;&#x4E00;&#x4E0B;&#x3002;


      supervisord
      &#x6211;&#x4EEC;&#x4E5F;&#x662F;&#x540E;&#x7AEF;&#x8FDB;&#x7A0B;&#x7528;&#x7684;&#x591A;&#xFF0C;&#x524D;&#x7AEF;&#x670D;&#x52A1;&#x5668;&#x7528;&#x7684;&#x662F;pm2~&#x5E94;&#x8BE5;&#x90FD;&#x5927;&#x540C;&#x5C0F;&#x5F02;~


      &#xFF08;&#x53E6;&#xFF1A;&#x6211;&#x53D1;&#x73B0;&#x6211;&#x7528;&#x7684;&#x8BC4;&#x8BBA;&#x7CFB;&#x7EDF;&#x5BF9;&#x8BA8;&#x8BBA;&#x7684;&#x652F;&#x6301;&#x5F88;&#x5DEE;&#xFF0C;&#x8003;&#x8651;&#x4EE5;&#x540E;&#x6362;&#x7528;GitHub
      Issues&#x6765;&#x505A;&#x8BC4;&#x8BBA;&#x7CFB;&#x7EDF;&#xFF09;
    date: 2017-11-23T09:56:43.983Z
  - author:
      type: github
      displayName: YemingLakeForest
      url: 'https://github.com/YemingLakeForest'
      picture: 'https://avatars2.githubusercontent.com/u/6832909?v=4&s=73'
    content: >-
      &#x50CF;java&#x7684;ant&#x548C;gradle&#xFF0C;maven&#x60E8;&#x88AB;&#x5FFD;&#x7565;&#x54C8;&#x54C8;&#x54C8;&#x3002;

      &#x5B57;&#x95F4;&#x6CA1;&#x7559;&#x7A7A;&#x683C;&#xFF0C;&#x51D1;&#x5408;&#x770B;&#x5427;
    date: 2019-06-27T09:51:54.033Z

---

本文主要讲述一下我司
（[一个成长中的创业公司][zaihui-intro]）
目前的代码发布流程用到了哪些工具。


<!--more-->


## 发布工具：[Jenkins][jenkins]

我们用的发布工具是[很多公司都在用][jenkins-stackshare]的[Jenkins][jenkins]。
举个~~栗子~~图，
在Jenkins Server上可以一键发布后端服务器代码：

![jenkins-demo][jenkins-demo]

按下 Build按钮 以后，
发生的事情如下：

* 在 Jenkins服务器 上触发预先配置的 Bash脚本
  * git命令获取到最新的代码版本，切换合适的分支
  * ~~执行代码风格检测和单元测试~~自从使用了付费版GitLab后，本功能已切换至GitLab CI了
  * 安全检查通过以后，使用fab命令部署代码


## 发布命令：[Fabric][fabric]

这里的fab命令用的就是[Python的Fabric库][fabric]，
这个库类似[ansible][ansible]，
主要包含两套功能：

* **本地命令集成**。
这点大概跟 Java 的 [`ant`][ant], [`gradle`][gradle],
或者是 JS 的 [`npm run`][npm] 有类似功能。
都是可以把数个操作集成到一条简单的工作流命令里。

* **远程ssh工具**。
[Fabric][fabric]里基于[ssh][ssh]，
实现了一套方便的远程命令接口，
比如这么一段代码就可以把配置上传到远程服务器：

```
from fabric.api import *  # NOQA

# 不用试了，这里的两个都是假的domain，对应放上ssh的host/user即可
env.hosts = ['www.kezaihui.com', 'zaihuiwebserver-814613977.cn-north-1.elb.amazonaws.com.cn']
env.user = 'saber'

def update_supervisor_config():
    put('./supervisor/*.conf', '/etc/supervisor/conf.d/', use_sudo=True)
    run('supervisorctl update', use_sudo=True)
```

但[Fabric][fabric]有个比较蛋疼的地方就是它只支持[Python2][which-python]，
假如要用[Python3][which-python]的话，
可以使用[Fabric][fabric]的一个fork分支[Fabric3][fabric3]，
[Fabric3][fabric3]与[Fabric][fabric]大部分功能等价。

只想用里面本地命令集成这部分功能的话，
还有一个库叫[Invoke][invoke]也提供了类似的功能。
这个库主要是名字特别帅，
[dota2里面的卡尔就叫Invoker（祈求者）][invoker]。


## 进程管理：[Supervisor][supervisor]

在正式环境中，
为了保证服务器进程的鲁棒性，
我们使用了 [supervisor][supervisor] 来监控进程状态。

一个简单的 nginx supervisor 的配置会长这样子：

```
[program:nginx]
command=/usr/sbin/nginx
autostart=true
autorestart=true
stdout_logfile=/var/log/supervisor/nginx.log
stderr_logfile=/var/log/supervisor/nginx_error.log
```

把配置文件放到 `/etc/supervisor/conf.d/nginx.conf` 以后，
就可以使用一系列命令把服务起起来：

```
$ supervisorctl update  # supervisorctl 是 supervisor 的命令行工具，更新一波配置
nginx    STARTING    pid 1000, uptime 0:00:00

$ supervisorctl status  # 查看进程状态
nginx    RUNNING     pid 1000, uptime 0:12:34

$ kill -9 1000  # 模拟各种波动，干掉 nginx 进程

$ supervisorctl status  # 再次查看进程状态，可以发现 supervisor 自动重启了
nginx    STARTING    pid 1020, uptime 0:00:00
```

## 总结

负责发版的工程师，
可能只在页面上点下了 `Build` 的一个按钮，
实际上的流程是这样的：

* Jenkins 触发了配置好的 Bash脚本。
* 里面 Bash 脚本跑了 fab 命令。
* fab 命令执行了代码上传的工作，本质上是通过 ssh 执行命令。
* 最终用 supervisor 开启/重启了进程服务。
* 发版完成。

以上大概就是我司目前自动化部署的简陋介绍。
升级之路漫漫，
还是有很多东西要学习/实践/掌握的呀。

> [原文链接][self]，[作者 @苏子岳][about-me]
>
> 本文版权属于再惠研发团队，欢迎转载，转载请保留出处。

[zaihui-intro]: https://www.zhihu.com/question/19596230/answer/152193862
[jenkins-stackshare]: https://stackshare.io/jenkins
[jenkins]: https://jenkins.io/
[jenkins-demo]: /assets/pics/zaihui_jenkins.jpg
[fabric]: https://github.com/fabric/fabric
[ansible]: https://github.com/ansible/ansible
[ant]: http://ant.apache.org/
[gradle]: https://gradle.org/
[npm]: https://www.npmjs.com/
[ssh]: https://en.wikipedia.org/wiki/Secure_Shell
[which-python]: http://docs.python-guide.org/en/latest/starting/which-python/
[fabric3]: https://github.com/mathiasertl/fabric/
[invoke]: http://www.pyinvoke.org/
[invoker]: https://dota2.gamepedia.com/Invoker
[supervisor]: http://supervisord.org/
[self]: /python-deployment-automation-one-sample
[about-me]: /about/

