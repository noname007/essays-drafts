---
title: Linux 内核分析 -- 系统调用的工作过程
layout: post
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-03-20 20:36:22
---


```shell

选择一个系统调用（13号系统调用time除外），系统调用列表参见http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/syscalls/syscall_32.tbl

参考视频中的方式使用库函数API和C代码中嵌入汇编代码两种方式使用同一个系统调用

根据本周所学知识分析系统调用的工作过程，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：

        题目自拟，内容围绕系统调用的工作机制进行
        博客中需要使用实验截图
        博客内容中需要仔细分析汇编代码调用系统调用的工作过程，特别是参数的传递的方式等。
        总结部分需要阐明自己对“系统调用的工作机制”的理解。
```


## 得到当前进程的进程号-- 两种实现方式

getpid()函数功能是返回`pid_t`（即`int`）类型的进程号，具体使用可以使用`man getpid`查看，C代码如下


```C

#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <unistd.h>
int main()
{
    printf("%d\n",getpid());
    return 0;
}


```


汇编代码实现，就是发起一个软中断，调起系统处理程序。其系统调用号可以在  http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/syscalls/syscall_32.tbl#29 此处看到。具体代码如下所示


```C

#include <stdio.h>
#include <stdlib.h>


int main()
{
    pid_t pid = 0;
    asm volatile(
        "mov $20,%%eax\n\t"
        "int $0x80\n\t"
        "mov %%eax,%0"
        :"=m"(pid)
    );

    printf("pid: ===asm:%d\n",pid);

    return 0;
}

```




## 系统调用的整个流程

系统调用简单来说，让操作系统来做一些在用户程序不易做到的事情，让操作系统代替用户程序去做。
添加了这样一层，这样一来就会在下面这几个层次上带来很多的好处：

- 可以避免用户程序可以直接操作硬件 
- 可移植性
- 安全性

简单总结一下系统调用的整个流程基本上就是：

1. 用户处理程序（上面的C程序）
2. api(`glibc` 封装的库函数 `getpid()`)
3. 软中断（`int $0x80`,使程序陷入到内核态）
3. 根据`系统调用号`，查找中断向量表
4. 调用中断处理程序。



## 检验汇编实现正确与否

写完汇编代码后怎么校检一下程序是怎么正确的呢，最简单的方式就和已有的标准程序结果对比一下，也就是对比一下C程序结果和汇编程序输出的结果。 


```C

#include <stdio.h>
#include <stdlib.h>

#include <sys/types.h>
#include <unistd.h>

int main()
{
    pid_t pid = 0;
    asm volatile(
     //   "mov $0 ,%%ebx;\n\t"  //传参数，返回值，不同情况，具体起怎么起的作用，还需要搞一下。
        "mov $20,%%eax\n\t"
        "int $0x80\n\t"
        "mov %%eax,%0"
        :"=m"(pid)
    );

    printf("pid: ===asm:%d===c:%d====\n",pid,getpid());

    return 0;
}

```



