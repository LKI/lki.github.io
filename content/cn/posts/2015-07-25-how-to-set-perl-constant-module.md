---
title:     "如何优雅地使用Perl的常量模块"
date:      2015-07-25 20:56:06
aliases:
  - /how-to-set-perl-constant-module
---

最近的Perl Coding遇到了一个问题：需要对一系列常量进行合法性检测。

在Research&Develop后，有一些心得。

本文从Perl的常量定义上，给出一个_自认为_优雅的解决方案。

<!--more-->

## Perl中一般的常量定义

在写项目的时候为了避免Magic Number的情况，我们经常需要定义常量。

当然了，根据[如何写出无法维护的代码][1]的指导我们不应当定义常量，Number越Magic越好。

一般来说，Perl中的常量如下：

```perl
    use constant CONST_PI => 3.1416;
```

在模块化的编码过程中，随着常量的增多，我们会需要把这些常量放到一个常量模块(Perl Module)里面：

这样的做法也符合DRY(Don't Repeat Yourself)的原则。#DRYBestPractice?

比如说在哼哧哼哧地写了一阵子以后，我们有下面这个常量模块。

```perl
    package Lirian::Constants;
    use strict;
    use warnings;

    #Math Const
    use constant CONST_PI => 3.1416;
    use constant CONST_E  => 2.718;

    #Default Config Parm Name
    use constant PARM_DB_NAME  => 'dbName';
    use constant PARM_DB_HOST  => 'dbHost';
    use constant PARM_GIT_USER => 'gitUser';

    require Exporter;
    our @ISA = qw(Exporter);

    our @EXPORT_OK = qw(
        CONST_PI
        CONST_E
        PARM_DB_NAME
        PARM_DB_HOST
        PARM_GIT_USER
    );

    our %EXPORT_TAGS = (
        all  => \@EXPORT_OK,
        math => [qw(
            CONST_PI
            CONST_E
        )],
        parm => [qw(
            PARM_DB_NAME
            PARM_DB_HOST
            PARM_GIT_USER
        )],
    );
```

上面这段代码简单粗暴地展示了Perl中的常量模块。

其中的`our @ISA = qw(Exporter);`是表示本模块继承了[Exporter][2]这个模块。

通过这样的定义，我们便有了一个常量的“中心仓库”了。

至于怎么使用，我们就来看下一节。


## 使用常量模块

在上一节中，通过对Exporter的继承，我们有了一个Lirian::Constants模块。

而一般地，我们会这么使用：

```perl
    package Lirian::Math;

    use Lirian::Constants qw(:all);
    use strict;
    use warnings;

    sub get_circum {
        my ($r) = @_;

        return 2 * CONST_PI * $r;
    }

    1;
```

在正常的情况下，常量的使用方法比较简单，但假如需求有些绕：

在程序的开始时，我们需要检验用户的配置文件，确保每个条目用户都是有效的。

比如说需求文件如下：

```config
    dbName=github
    dbHost=localhost
    gitUser=LKI
```

显然地，一种简单但稍微蠢了点的方法是这么做：

```perl
    sub validate_config_dumb {
        my ($conf) = @_;

        validate_parm($conf, PARM_DB_NAME);
        validate_parm($conf, PARM_DB_HOST);
        validate_parm($conf, PARM_GIT_USER);
    }
```

这样做有几个问题：

1.config parameter一多，代码就很长，丑
2.增加config constant时，不仅要改常量模块，这里也要加，累
3.这样的代码提交上去感觉好丢脸，蠢
4.以上三点在[撞大运编程][3]里都不是问题

那怎么样做才算是优雅的做法呢？


## 利用Perl的Export机制

在Exporter中，定义在%EXPORT_TAGS中的文件可以直接引用：

```perl
    my $tags      = \$Lirian::Constants::EXPORT_TAGS;
    my $math_tags = $tags->{math}; # ['CONST_PI', 'CONST_E'];
    my $parm_tags = $tags->{parm}; # ['PARM_DB_NAME', 'PARM_DB_HOST', 'PARM_GIT_USER'];
```

这样就可以拿到常量的名字了，此时我们便需要[在Perl中根据变量名获取变量值][4]

```perl
    my $name  = 'CONST_PI';
    my $value = Lirian::Constants->$name; # 3.1416
```

所以在上一小节的问题中，我们可以得出一个更优雅的解决方案啦~

```perl
    sub validate_config {
        my ($conf) = @_;

        my $tags      = \$Lirian::Constants::EXPORT_TAGS;
        my $parm_tags = $tags->{parm};
        foreach my $parm_name (@$parm_tags) {
            my $parm_value = Lirian::Constants->$parm_name;
            validate_parm($conf, $parm_value);
        }
    }
```

大功告成！从此以后在加常量的同时，validate_config会自动地检验新增的配置选项啦~

此时便可以使用[一个酷炫的Git Commit Message][5]来提交工作啦！

[1]:https://coolshell.cn/articles/4758.html
[2]:http://perldoc.perl.org/Exporter.html
[3]:https://coolshell.cn/articles/2058.html
[4]:http://stackoverflow.com/questions/2187682/how-do-i-access-a-constant-in-perl-whose-name-is-contained-in-a-variable
[5]:http://whatthecommit.com/
