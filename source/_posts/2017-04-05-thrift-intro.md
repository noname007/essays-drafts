---
layout: post
title:  "thrift 入门学习 笔记"
date:   2017-04-05 13:44:12 +0800
categories: notes
tags: [thrift,总结,技术]
published: true
description: thrif 笔记
---
* 目录
{:toc}


## 入门教程
可以参考其中的一个做下简单的整体了解

1. thrif 入门
    - [http://www.jianshu.com/p/0f4113d6ec4b  ](http://www.jianshu.com/p/0f4113d6ec4b  )
2. thrif 入门
   - [http://wuchong.me/blog/2015/10/07/thrift-induction/](http://wuchong.me/blog/2015/10/07/thrift-induction/)
   - [http://wuchong.me/blog/2015/10/07/thrift-practice/](http://wuchong.me/blog/2015/10/07/thrift-practice/)

## 深入一点
更加深入的了解一些 thrift 内部类、方法可以参考这个系列的三篇文章，

1. [http://dongxicheng.org/search-engine/thrift-framework-intro/](http://dongxicheng.org/search-engine/thrift-framework-intro/)
2. [http://dongxicheng.org/search-engine/thrift-guide/](http://dongxicheng.org/search-engine/thrift-guide/)
3. [http://dongxicheng.org/search-engine/thrift-rpc/](http://dongxicheng.org/search-engine/thrift-rpc/)


系列还有一篇 浅谈Thrift内部实现原理 的文章，

​[http://dongxicheng.org/search-engine/thrift-internals/](http://dongxicheng.org/search-engine/thrift-internals/)


讲的不是那么容易理解，直接分析生成的 c++的代码，初步的参考价值反而不如前三篇文章大。

这个系列我感觉还缺少一篇这样的文章：

    分析rpc通信数据具体格式，序列化、反序列化的过程中如何跟具体的一门语言对象是如何对应的。

当然这个要求难度还是挺难的。：）
