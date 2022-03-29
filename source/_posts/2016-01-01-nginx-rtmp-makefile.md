---
title: ubuntu 一键自动部署 nginx-rtmp
layout: post
tags:
  - 笔记
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2016-03-29 20:56:40
---

>琐碎细节的东西规范化、流程化，流程规范的东西自动化 —— 忘记从哪里看到的了，欢迎作者联系


rtmp 笔记:

- [【译】How to set up your own private RTMP server using nginx](/2015/08/12/How-to-set-up-your-own-private-RTMP-server-using-nginx/)
- [nginx 点播](/2015/08/17/vod/)
- [nginx-rtmp-module 总结](2015/09/06/rtmp/)
- [做的一次简单内部分享](http://p1.soul11201.com/remark-presentation/#1)

---

最近半年一直在搞 nginx-rtmp 这一套东西，时不时的需要在某台机器上安装，今天抽空写了一个makefile 可以实现一键自动部署。

- 系统 Ubuntu 15.10 
- nginx 1.8.1 stable
- rtmp master 分支


运行无问题makefile 如下:(最好先创建一个目录 `mkdir nginx-rtmp && cd nginx-rtmp`)

```Makefile
PWD = $(shell pwd)
#process the condition of the file have exists
default: install
nginx:
        echo $(PWD),"11"        
        test  -f '$(PWD)/nginx-1.8.1.tar.gz' || wget http://nginx.org/download/nginx-1.8.1.tar.gz 
        test  -f '$(PWD)/nginx-1.8.1.tar.gz' && (test -d '$(PWD)/nginx-1.8.1'   || tar -zxvf nginx-1.8.1.tar.gz)
rtmp-mod:
        test -f '$(PWD)/master.zip' || wget https://github.com/arut/nginx-rtmp-module/archive/master.zip 
        test -f '$(PWD)/master.zip' && (test -d '$(PWD)/nginx-rtmp-module-master' || unzip master.zip )
dep:
        sudo apt-get install build-essential libpcre3 libpcre3-dev  libssl-dev

install: nginx rtmp-mod dep
        cd nginx-1.8.1 && ./configure --add-module=../nginx-rtmp-module-master/ --with-debug && make && sudo make install

```

写makefile的时候主要卡在了下了下面两个地方

### 获取当前目录
获取当前目录的时候开始使用 **PWD =\`pwd\`** 在test 指令的时候一直不起作用，最后改用`PWD = $(shell pwd) `[^1]。但是获取的路径的最后面一直有个空格，居然还准备用`tr -d ' '` 去除字符串中的空格 [^3]，并没有起什么卵用，反而又出来一堆问题。重新研究自己写的代码，发现写为 `PWD = $(shell pwd)`，问题立马解决。

### 测试文件存在
测试文件存在的时候开始使用if指令来做的[^2]，但是一直有语法错误，遂改用test 指令。



[^1]: http://blog.sina.com.cn/s/blog_89fa41ef0100yzhf.html
[^2]: http://www.cnblogs.com/sunyubo/archive/2011/10/17/2282047.html
[^3]: http://bbs.chinaunix.net/thread-498702-1-1.html
