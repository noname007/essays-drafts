title: mooc-linux-kernel-6
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-04-01 20:20:46
---

{% blockquote %}
杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://mooc.study.163.com/course/USTC-1000029000
{% endblockquote %}

{% blockquote %}
杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程  http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about
{% endblockquote %}



- 阅读理解task_struct数据结构http://codelab.shiyanlou.com/xref/linux-3.18.6/include/linux/sched.h#1235；
- 分析fork函数对应的内核处理过程sys_clone，理解创建一个新进程如何创建和修改task_struct数据结构；
- 使用gdb跟踪分析一个fork系统调用内核处理函数sys_clone ，验证您对Linux系统创建一个新进程的理解,推荐在实验楼Linux虚拟机环境下完成实验。 特别关注新进程是从哪里开始执行的？为什么从那里能顺利执行下去？即执行起点与内核堆栈如何保证一致。
- 根据本周所学知识分析fork函数对应的系统调用处理过程，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：
    + 题目自拟，内容围绕对Linux系统如何创建一个新进程进行；
    + 可以结合实验截图、绘制堆栈状态执行流程图等；
    + 博客内容中需要仔细分析新进程的执行起点及对应的堆栈状态等。
    + 总结部分需要阐明自己对“Linux系统创建一个新进程”的理解

[^1]: http://blog.csdn.net/npy_lp/article/details/7292563
[^2]: http://www.2cto.com/os/201201/116810.html