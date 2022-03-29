---
layout: post
title:  编译、链接、装载
date:   2020-01-22 17:42:55 +0800
published: true
---


```shell
$ gcc  -g  -v -Wall -c  -fPIC minus.c add.c
$ gcc  -g  -v -Wall -shared  -o libmycal.so add.o minus.o
$ ar rcs libmycal.a add.o minus.o
$ gcc  -g  -v -Wall main.c libmycal.so
```
