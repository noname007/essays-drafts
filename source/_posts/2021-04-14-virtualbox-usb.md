---
layout: post
title:  arch virtualbox 中 win7  无法识别 usb 
date:   2021-04-14 16:27:01 +0800
---


yay -S virtualbox-ext-oracle virtualbox virtualbox-guest-iso

sudo modprobe vboxdrv

sudo usermod -a -G  vboxusers `whoami`

reboot


https://bbs.archlinux.org/viewtopic.php?id=194816
https://bbs.archlinuxcn.org/viewtopic.php?id=4581
https://www.linuxtechi.com/install-virtualbox-on-arch-linux/
https://blog.csdn.net/moliqin/article/details/79588382
http://ivo-wang.github.io/2018/02/22/arch-virtualbox-usb/


