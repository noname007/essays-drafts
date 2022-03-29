---
title: Linux 内核分析 -- 装载
layout: post
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-04-08 19:09:41
---



<!-- 1. 理解编译链接的过程和ELF可执行文件格式，详细内容参考本周第一节；​
2. 编程使用exec*库函数加载一个可执行文件，动态链接分为可执行程序装载时动态链接和运行时动态链接，编程练习动态链接库的这两种使用方式，详细内容参考本周第二节；
3. 使用gdb跟踪分析一个execve系统调用内核处理函数sys_execve ，验证您对Linux系统加载可执行程序所需处理过程的理解，详细内容参考本周第三节；推荐在实验楼Linux虚拟机环境下完成实验。
特别关注新的可执行程序是从哪里开始执行的？为什么execve系统调用返回后新的可执行程序能顺利执行？对于静态链接的可执行程序和动态链接的可执行程序execve系统调用返回时会有什么不同？

根据本周所学知识分析exec*函数对应的系统调用处理过程，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：
题目自拟，内容围绕对Linux内核如何装载和启动一个可执行程序；
可以结合实验截图、ELF可执行文件格式、用户态的相关代码等；
博客内容中需要仔细分析新可执行程序的执行起点及对应的堆栈状态等。
总结部分需要阐明自己对“Linux内核装载和启动一个可执行程序”的理解 -->

### 编译链接的过程，ELF文件格式 

![][build-png]

[build-png]: /imgs/gcc-build-process-1.png "生成可执行程序的过程" { width=100%}

<!-- [^zhihu] -->

[^zhihu]: [linux中的动态链接库，和静态链接库是干什么的？](https://www.zhihu.com/question/20484931)

生成可执行程序的过程 [^meihuaxiaozhu]

- C代码（.c）经过编译器预处理生成中间代码（图中未显示），然后编译成汇编代码（.asm） 
- 汇编代码（.asm）经过 汇编器，生成目标文件（.o）
- 目标文件（.o） 经过链接器，链接成可执行文件（.out） 
- OS将可执行文件加载到内存里执行.

其中，.o文件 和 可执行文件，都是目标文件，Linux上面目标文件格式是 `Elf`,window上面是`PE格式`。

ELF格式的目标文件种类[^meihuaxiaozhu],[^ziwoxiuyang] 

- 可重定位（relocatable）文件，保存着代码和适当的数据，用来和其它的object文件一起来创建一个可执行文件或者是一个共享文件（主要是.o文件）
- 可执行（executable）文件，保存着一个用来执行的程序，该文件指出了exec(BA_OS)如何来创建程序进程映象（操作系统怎么样把可执行文件加载起来并且从哪里开始执行）
- 一个共享文件（如Linux中的.so,.dso文件）即动态链接库，保存着代码和合适的数据，链接方式有两种，静态链接（装载时连接），动态链接（程序运行时连接）


## 动态链接库的这两种使用方式

## gdb跟踪`execve`系统调用 --- 可执行程序的装载过程 

设置断点
 
 ```gdb
 b sys_execve
 b load_elf_binary
 b start_thread
 ```

从哪里开始执行的

[^meihuaxiaozhu]: [梅花小筑](http://www.jianshu.com/p/dee889469bdd)
[^ziwoxiuyang]:  [程序员的自我修养：链接、装载与库](http://item.jd.com/10067200.html) 
