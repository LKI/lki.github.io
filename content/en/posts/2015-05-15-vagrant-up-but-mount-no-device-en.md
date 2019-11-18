---
title:     "Solution for vagrant-up error: mount no device"
date:      2015-05-15 10:29:05
zhUrl:     /vagrant-up-but-mount-no-device-zh
aliases:
  - /vagrant-up-but-mount-no-device-en
---

Today I encounter a problem running ```vagrant up```：

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

Refer to https://github.com/mitchellh/vagrant/issues/1657 

_This is usually a result of the guest’s package manager upgrading the

kernel without rebuilding the VirtualBox Guest Additions_ by lenciel. So
we run vboxadd accordingly:

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

From the message we can know current running kernel were not found. So
we run:```yum install kernel-devel-2.6.18-404.el5```

After all, we can run ```vagrant up``` or mount the directory manually.
