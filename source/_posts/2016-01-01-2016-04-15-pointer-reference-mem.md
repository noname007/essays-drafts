---
title: 指针、引用与内存
layout: post
tags:
  - 笔记
  - c
  - c/c++
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2016-04-15 12:39:41
---

> 1. 指针两个变量之间的关系是什么,`T *a,*b = a`;
> 1. 引用两个变量之间的关系是什么,`T *a,* &b = a`？
> 3. delete后堆上数据有没有回收怎么判断？
> 4. 类的函数中可以使用`delete this`吗？
> 


## 引用
一般类型引用格式是：`T a,&b = a`表示变量a,b指向了同一块内存区域。可以使用如下方式验证
```C
    printf("%x\n",&a);
    printf("%x\n",&b);
```


指针类类型的引用：

`T *a,*b = a` 在内存中有两块内存区域。

`T *a,*&b = a` 内存中有一块内存区域

`int *a = new int` 在堆上申请一块内存区域，地址赋值给a。

`delete a` 回收`a`所指向的堆上的内存。但是`a == NULL`不一定成立


<!-- 指针b是指针a的引用 -->




## 指针、delete、new


内存使用的基本规则:
>谁使用谁回收