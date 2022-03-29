---
layout: post
title:  基于树莓派 + ArchLinux + Cups + Saltstack的打印管理
date:   2020-10-16 14:59:00 +0800
---

* 目录
{:toc}


## 树莓派安装 ArchLinux  ##

https://qsctech-sange.github.io/arch-on-Raspberrypi.html

https://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/os/

### pacman guide ###

https://kaosx.us/docs/pacman/

## ArchLinux 配置网络 ##

网线与 wifi 同时启用，网线优先级更高。


### iproute###

https://blog.csdn.net/leshami/article/details/78021859

### dhcpd ###

https://wiki.archlinux.org/index.php/Dhcpcd

### wpa_supplicant ###

https://w1.fi/cgit/hostap/plain/wpa_supplicant/README
https://wiki.archlinux.org/index.php/Wpa_supplicant


https://www.zcfy.cc/article/how-to-update-wifi-network-password-from-terminal-in-arch-linux

https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4


## ArchLinux 安装 Cups ##

	pacman -Syy cups cups-pdf colord ipp-usb logrotate docx2txt  antiword foomatic-db-nonfree foomatic-db-engine foomatic-db  foomatic-db-gutenprint-ppds  gutenprint foomatic-db-nonfree-ppds  gsfonts ghostscript hplip


https://wiki.archlinux.org/index.php/CUPS

https://developers.hp.com/hp-linux-imaging-and-printing/about


https://docs.oracle.com/cd/E26926_01/html/E25812/gllhj.html#gjokv

### cups 作为 systemd 服务 ###

https://superuser.com/questions/490713/arch-linux-cannot-start-cups-service-with-systemd
http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html

###  打印管理 -- 基于 Cups ###

https://blog.csdn.net/lhf_tiger/article/details/8055380

### Cups Pdf ###

Ubuntu18.04 配置Cups PDF虚拟打印机服务 https://my.oschina.net/u/4400737/blog/3244045

https://www.archlinux.org/packages/extra/x86_64/cups-pdf/



## Saltstacks 管理树莓派 ##

[Learning SaltStack - Second Edition](https://www.packtpub.com/product/learning-saltstack-second-edition/9781785881909)



### 安装 Saltstacks###

https://docs.saltstack.com/en/latest/topics/installation/index.html#quick-install

https://github.com/saltstack/salt-bootstrap
### salt minion id 如何生成？ ###

	cat /etc/machine-id| xargs -n 1 hostnamectl set-hostname | hostnamectl && cat /etc/hostname
	

#### machine id 调研 ####

http://manpages.ubuntu.com/manpages/bionic/man5/machine-id.5.html
https://jlk.fjfi.cvut.cz/arch/manpages/man/machine-id.5.zh_CN
https://unix.stackexchange.com/questions/402999/is-it-ok-to-change-etc-machine-id

### 管理命令 ###

https://blog.51cto.com/6226001001/1909013


### s3 文件下载 ###

https://salt-zh.readthedocs.io/en/latest/ref/modules/all/salt.modules.s3.html

### salt-api ###

https://jaminzhang.github.io/saltstack/SaltStack-API-Config-and-Usage/

https://blog.51cto.com/6226001001/1909013

### [TODO] --- SaltStack 多 Master 架构 ###

https://jaminzhang.github.io/saltstack/SaltStack-MultiMaster-Architecture/

### salt 事件转发到 普罗米修斯 监控 ###

