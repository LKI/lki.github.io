---
title:     "Vagrant-up遇到mount no device的解决方案"
date:      2015-05-15 10:29:05
enUrl:     /vagrant-up-but-mount-no-device-en
aliases:
  - /vagrant-up-but-mount-no-device-zh
---

今天跑```vagrant up```的时候遇到了这个问题：

<!--more-->

```
==> cvc-tools: Machine booted and ready!
==> cvc-tools: Checking for guest additions in VM...
==> cvc-tools: Configuring and enabling network interfaces...
==> cvc-tools: Mounting shared folders...
    cvc-tools: /work => D:/work/
Failed to mount folders in Linux guest. This is usually because
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly. The command attempted was:

mount -t vboxsf -o uid=`id -u devel`,gid=`getent group devel | cut -d:
-f3` work /work
mount -t vboxsf -o uid=`id -u devel`,gid=`id -g devel` work /work

The error output from the last command was:

/sbin/mount.vboxsf: mounting failed with the error: No such device
```

查看了 https://github.com/mitchellh/vagrant/issues/1657
以后，明白这是```yum update```更新了内核，但是没有更新VirtualBox的连接的问题。

于是重新添加一下VBox：

```
[lirian@localhost ~]$ sudo /etc/init.d/vboxadd setup
Removing existing VirtualBox non-DKMS kernel modules       [  OK  ]
Building the VirtualBox Guest Additions kernel modules
The headers for the current running kernel were not found. If the
following
module compilation fails then this could be the reason.
The missing package can be probably installed with
yum install kernel-devel-2.6.18-404.el5

Building the main Guest Additions module                   [FAILED]
(Look at /var/log/vboxadd-install.log to find out what went wrong)
Doing non-kernel setup of the Guest Additions              [  OK  ]
```

根据以上信息，得知现在在跑的内核开发包缺失，于是再跑一下：

```yum install kernel-devel-2.6.18-404.el5```

之后再vagrant up或者手动mount就可以解决问题了。

总结：vagrant up遇到mount error: no such device可以通过以下脚本解决：

```
yum install kernel-devel-2.6.18-404.el5
/etc/init.d/vboxadd setup
mount -t vboxsf -o uid=`id -u devel`,gid=`id -g devel` work /work
```
