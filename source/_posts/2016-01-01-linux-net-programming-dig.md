---
title: Linux 高性能服务器编程 
layout: post
date: 2015-10-14 17:40:49
tags:
- linux
- c
- 笔记
- 摘抄
---
##IO 复用函数
##定时器

**定时方法**
 * socket 选项 SO_RCVTIMEO 和SO_SNDTIMEO
 *  SIGALRM信号
 *  I/O复用系统调用的超时参数


SO_RCVTIMEO  SO_SNDTIMEO 设置接受、发送数据超时时间
