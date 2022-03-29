---
title: Linux 内核分析 -- 系统调用的工作过程（二）
layout: post
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-03-26 22:39:17
---

```


    使用gdb跟踪分析一个系统调用内核函数（您上周选择的那一个系统调用），系统调用列表参见http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/syscalls/syscall_32.tbl ,推荐在实验楼Linux虚拟机环境下完成实验。
    根据本周所学知识分析系统调用的过程，从system_call开始到iret结束之间的整个过程，并画出简要准确的流程图，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：
    题目自拟，内容围绕系统调用system_call的处理过程进行；
    博客内容中需要仔细分析system_call对应的汇编代码的工作过程，特别注意系统调用返回iret之前的进程调度时机等。
    总结部分需要阐明自己对“系统调用处理过程”的理解，进一步推广到一般的中断处理过程。

```


### 用到的 gdb 命令

已知的含义功能的就不赘述了。

|指令/参数|功能|
|---||
|file |加载符号表|
|b||
|s||
|finish|完成函数执行，跳出函数|
|n||
|c||
|l||

### 用到的  qemu 参数
|||
|---|---|
|-s||
|-S||

### 系统调用断点设置

系统调用列表 http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/syscalls/syscall_32.tbl 格式为

`<number> <abi> <name> <entry point> <compat entry point>`
含义为：

|||
|---|---|
|number|系统调用号|
|abi|cpu 架构|
|name|系统调用名
|entry point| 系统调用，中断服务处理程序名|
|compat entry point|entry point 别名|

### 进程调度的整个流程






1. 调用 [`trap_init()`](http://codelab.shiyanlou.com/xref/linux-3.18.6/init/main.c#561)  [初始系统中断向量表](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/traps.c#838) 
 ```C
	#ifdef CONFIG_X86_32
	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
	set_bit(SYSCALL_VECTOR, used_vectors);
	#endif
 ```

2. 调用中断处理程序 [system_call](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#490)
 + 保存现场 SAVE_ALL
 + 根据具体是系统调用号，调用具体的中断服务处理程序
  [`call *sys_call_table(,%eax,4)`](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#502)
 + 信号处理、进程调度，其代码执行流程简化如下：
   - [`jne syscall_exit_work`](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#513)
   - [`jz work_pending`](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#658)
   - [`work_resched`
	`call schedule`](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#586)
3. 调用结束，恢复
    [`restore_all`](http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/entry_32.S#515)

<!--
system_call 断点可以设置，但是程序运行的时候会直接跳过去 
-->




