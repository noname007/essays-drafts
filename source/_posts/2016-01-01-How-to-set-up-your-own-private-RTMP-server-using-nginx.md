---
title: '【译】How to set up your own private RTMP server using nginx'
layout: post
tags:
  - 翻译
  - rtmp
  - nginx
date: 2015-08-12 17:20:51
---

> 原文地址: https://obsproject.com/forum/resources/how-to-set-up-your-own-private-rtmp-server-using-nginx.50/

大多数人喜欢使用Twitch.tv和Ustream这类服务把流视频转播放给用户，并且工作的也非常好。但是有时候你想对你的流视频有更多的控制权，或者你想其他人把视频流转发给你，或者你想转发视频流到多个地方，或者一些事情需要你有权限访问RTMP服务器上的视频流。这篇教程内容非常基础，教你在一台linux服务器上搭建一个简单的RTMP服务器。

在你自己RTMP服务器上，你可能感兴趣去做的是这两件事情：
   - 向多个频道播放内容
   - 由于一些目的，把其他人的多个视频流合成一个（我在多个角度拍摄中使用它，例如像在[这个多个拍摄角度视频中](https://www.youtube.com/watch?v=6WUU58POsTM)）

好的，你该怎样做到这些事情呢？

##  第一步：获取一个服务器
不管你信不信，RTMP 实际上对系统资源要求十分的小。本质上来说，它仅仅是从输入端抓取数据并把数据转发到输出端，简单的数据传输。不相信我？我的运行了很长一段时间的RTMP服务器是一个树莓派,一个价值35美金（月200元人民币）的迷你计算机，就放在我的办公桌上，至少同时处理3个数据输入流是完全没有问题的，我也从来没有对它进行过压力测试去看看到底他能处理多少。因此，我向你保证，即使一个便宜的旧机器也是完全没有问题的。

假如你没有树莓派，一个vps也是可以的。我推荐Linode服务商，如果你能支付的起服务费用。我现在也在使用，并且到现在为止，它也运行良好。仅仅确保你有足够的带宽。。。记住带宽的使用量是`（视频流的大小）* （上传人数+下载人数）`。因此当我有两个视频流推送视频流到我的服务器，并且我同时下载他们，两小时消耗了10GB的带宽流量。

为了方便，我推荐使用Ubuntu作为服务器软件，但是你完全可使用任何你想使用的。只要你能从apt之外其他的地方解决nginx的依赖问题，你就能参考这篇文档。

**Windows 用户注意** 这边教程关注Linux上的使用，假如你想在Windows上使用，你能找到带有RTMP 模块的nginx二进制包，在这个地方： http://nginx-win.ecsds.eu/

假如你的服务器在你家里，你需要转发TCP 1935端口数据到这个服务器上。。。不同的路由器有不同的设置，因此你需要根据你自己的路由器，查看怎么设置端口转发。同时，我推荐使用 DynDNS 这类服务去克服家用主机动态IP的问题。

## 第二步：安装nginx 和RTMP 模块
登录你的机器，并且确保你有这些必须的工具去编译nginx,执行下面的命令
    
    $ sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev

现在说点关于nginx的一点小知识（发音 "engine-X"）。nginx是个轻量级的web server，但是有些人为它写了一个RTMP模块，因此它能够提供RTMP流相关的服务，为了添加这个RTMP模块，我们必须重新从源码编译nginx 而不是使用apt包。不要担心，它是非常简单的，仅仅执行下面的指令:)

在你的home目录，下载nginx 源码：

    $ wget http://nginx.org/download/nginx-1.7.7.tar.gz

在写这篇文章的时候，ngxin 最新的稳定版本是 1.7.7。你可是从[nginx 下载页](http://nginx.org/en/download.html)下载最新的包。

接着，从git 获取RTMP 模块的源代码

    $ wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

解压开他们，斌且进入nginx 目录：

```shell
$ tar -zxvf nginx-1.7.7.tar.gz
$ unzip master.zip
$ cd nginx-1.7.7
```

现在，编译nginx:

```shell
$ ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
$ make
$ sudo make install
```

现在nginx 安装完毕了！默认安装在了 `/usr/local/nginx`,使用下面的命令启动：

    $ sudo /usr/local/nginx/sbin/nginx

现在测试一下确认nginx 正在运行，打开浏览器输入 `http://服务器ip/ ` 然后你将看到"Welcome to nginx!"这个页面。

## 第三步：配置nginx 启用RTMP
打开配置文件，默认是 `/usr/local/nginx/conf/nginx.conf`，在文件的最后添加下面的内容：

```nginx
rtmp {
        server {
                listen 1935;
                chunk_size 4096;

                application live {
                        live on;
                        record off;
                }
        }
}

```
这是一个非常简单的基础配置，有一个live应用，它将会把RTMP视频流转发给所有请求这它的用户。你可能过一会才播放这个视频。[这里是所有配置选项](https://github.com/arut/nginx-rtmp-module/wiki/Directives)，展示了如何转发视频流到其他的地方（像Twitch），保存上传的记录，输出状态等等。

重启nginx:

    $ sudo /usr/local/nginx/sbin/nginx -s stop
    $ sudo /usr/local/nginx/sbin/nginx


## 第四步：测试

你的服务器应该能接收RTMP视频流了。让我们尝试一下吧。

创建一个新的工程在OBS,并且更改 Broadcast Settings 为如下：
    
```conf
Streaming Service: Custom
Server: rtmp://<your server ip>/live
Play Path/Stream Key: test
```

你可能会疑惑test路径从哪里来。好吧，我们就是刚刚创建的。你能创建任何路径和流，把那个路径发到RTMP播放器里面，就可以播放了。对于简单的应用，没必要授权。

你现在能向你的服务器推送视频流了。当你点击了 "Start Streaming" ，没有报告错误，这是一个好的信号。

怎么打开观看呢？就我个人来说，我使用[vMix][vMix]播放RTMP流并且将多个视频流合并成一个我自己的流。如果你仅仅想播放一个正在上传的视频流，可以使用`VLC 2.1.0`或者更新的版本。打开一个网络流，输入`rtmp://<your server ip>/live/test`作为url。如果没有报什么错误的话，现在你就能在VLC里面看到流里面的内容了。

现在你有一个能工作的视频流了，欢呼吧:)

## 现在做什么呢？


你能使用使你的服务器转发视频流到其他的流服务和频道。在"record off;"后面添加下面的指令。

    push rtmp://<other streaming service rtmp url>/<stream key>

任何视频流都会被转发，同时客户端也能使用这个地址播放视频。你可以添加多个push指令，把这个视频转发到多个位置。

## FAQ

Q:为什么使用nginx?不使用crtmpserver/Red5/Wowza?

A:先前用过crtmpserver，并且也能工作，但是太难用了。如果需要RTSP服务代替RTMP服务，我推荐使用它，因为nginx RTMP模块不支持RTSP。对于我来说Red5看起来太重，太复杂了，并且是用java写的。。。如果你想使用它就是用它吧。我没有在这上面投资很多精力。Wowza不是免费的。你能使用它完成你想的功能，但是nginx是更轻量级的，易于使用，并且免费。

Q:X怎么做?

A:FAQ会保持更新。。问一些问题，我将把答案写在这里。




[vMix]: http://vmix.com.au/
