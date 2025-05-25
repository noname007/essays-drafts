---
layout: post
title:  编译、链接、装载
date:   2020-01-22 17:42:55 +0800
categories:
- 技术
tags:
- Linux
- C
- 构建
published: true
description: "编译动态链接库"
---


```shell
$ gcc  -g  -v -Wall -c  -fPIC minus.c add.c
$ gcc  -g  -v -Wall -shared  -o libmycal.so add.o minus.o
$ ar rcs libmycal.a add.o minus.o
$ gcc  -g  -v -Wall main.c libmycal.so
```
