---
title: Linux 内核分析 -- 进程的启动和进程的切换机制
layout: post
date: 2016-03-05 12:02:45
tags:
- mooc 
- 笔记
- Linux 内核分析
- 汇编
- C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
---

```shell
实验要求：

完成一个简单的时间片轮转多道程序内核代码，代码见视频中或从[mykernel](https://github.com/mengning/mykernel)找。
详细分析该精简内核的源代码并给出实验截图，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：

- 题目自拟，内容围绕操作系统是如何工作的进行；
- 博客中需要使用实验截图
- 博客内容中需要仔细分析进程的启动和进程的切换机制
- 总结部分需要阐明自己对“操作系统是如何工作的”理解。
```


## 中断
现代计算机实现多道程序设计的基础是出现了中断这一技术。中断意如其名，打断你原来的正在做的事情，比如说放假的时候在家看苦逼的写着作业的时候，突然有人打来电话约你。应约，还是继续写作业，具体你会怎么做呢？具体的行为，可以认为是中断处理程序。

## 进程调度实现

1. 程序加载完后就会执行这段[初始化代码](https://github.com/mengning/mykernel/blob/master/mymain.c#L25-L57) 
2. 同时还会检测时钟中断，并调用这段[中断处理程序](https://github.com/mengning/mykernel/blob/master/myinterrupt.c#L27-L38)， 


## my_start_kernel 都做了写什么呢？

```c
void __init my_start_kernel(void)
{
    int pid = 0;
    int i;
    /* Initialize process 0*/
    task[pid].pid = pid;
    task[pid].state = 0;/* -1 unrunnable, 0 runnable, >0 stopped */
    task[pid].task_entry = task[pid].thread.ip = (unsigned long)my_process;
    task[pid].thread.sp = (unsigned long)&task[pid].stack[KERNEL_STACK_SIZE-1];
    task[pid].next = &task[pid];
    /*fork more process */
    for(i=1;i<MAX_TASK_NUM;i++)
    {
        memcpy(&task[i],&task[0],sizeof(tPCB));
        task[i].pid = i;
        task[i].state = -1;
        task[i].thread.sp = (unsigned long)&task[i].stack[KERNEL_STACK_SIZE-1];
        task[i].next = task[i-1].next;
        task[i-1].next = &task[i];
    }
    /* start process 0 by task[0] */
    pid = 0;
    my_current_task = &task[pid];

    asm volatile(
        "movl %1,%%esp\n\t"     /* set task[pid].thread.sp to esp */
        "pushl %1\n\t"          /* push ebp */
        "pushl %0\n\t"          /* push task[pid].thread.ip */
        "ret\n\t"               /* pop task[pid].thread.ip to eip */
        "popl %%ebp\n\t"
        : 
        : "c" (task[pid].thread.ip),"d" (task[pid].thread.sp)   /* input c or d mean %ecx/%edx*/
    );
} 
```


初始化代码做的事情

 - 创建进程 
 - 初始化每个进程的堆栈位置
 - 进程之间的调度顺序，其实就是一个接一个的执行，没有什么优先级
 - 初始化根进程
 - 每个进程的功能都是一样的，指向了[`void my_process(void)`](https://github.com/mengning/mykernel/blob/master/mymain.c#L58-L75)，即代码注释中所说的 fork
 - 启动pid=0的进程，即代码中嵌入式汇编代码

```c
{
    asm volatile(
        "movl %1,%%esp\n\t"     /* set task[pid].thread.sp to esp */
        "pushl %1\n\t"          /* push ebp */
        "pushl %0\n\t"          /* push task[pid].thread.ip */
        "ret\n\t"               /* pop task[pid].thread.ip to eip */
        "popl %%ebp\n\t"
        : 
        : "c" (task[pid].thread.ip),"d" (task[pid].thread.sp)   /* input c or d mean %ecx/%edx*/
    );
}
```


这段代码什么做了那些事情那呢？

- 切换堆栈

 ```c 
 "movl %1,%%esp\n\t"     /* set task[pid].thread.sp to esp */
 "pushl %1\n\t"          /* push ebp */
 ```

- 指令跳转，使cpu指向进程代码入口

 ```c
 "pushl %0\n\t"          /* push task[pid].thread.ip */
 "ret\n\t"               /* pop task[pid].thread.ip to eip */
 ```

## 进程如何切换的？

从`void my_process(void)`，可以看出进程是每经过一段时间检查一下（利用硬件中断实现的）是否需要执行`my_schedule();`函数进行进程切换（根据`my_need_sched`来判断）。

```
void my_process(void)
{
    int i = 0;
    while(1)
    {
        i++;
        if(i%10000000 == 0)
        {
            printk(KERN_NOTICE "this is process %d -\n",my_current_task->pid);
            if(my_need_sched == 1)
            {
                my_need_sched = 0;
                my_schedule();
            }
            printk(KERN_NOTICE "this is process %d +\n",my_current_task->pid);
        }     
    }
}
```

下面分析一下进程切换的时候所做的一些事情。（去除了部分代码，以两个都是在运行态进程间的切换代码为例）




```c
void my_schedule(void)
{
  
        ...
        ...
        asm volatile(   
            "pushl %%ebp\n\t"       /* save ebp */
            "movl %%esp,%0\n\t"     /* save esp */
            "movl %2,%%esp\n\t"     /* restore  esp */
            "movl $1f,%1\n\t"       /* save eip */  
            "pushl %3\n\t" 
            "ret\n\t"               /* restore  eip */
            "1:\t"                  /* next process start here */
            "popl %%ebp\n\t"
            : "=m" (prev->thread.sp),"=m" (prev->thread.ip)
            : "m" (next->thread.sp),"m" (next->thread.ip)
        );
        ...
        ...

}
```


- 切换堆栈，包括旧堆栈以及现场保存，新堆栈的建立
 ```c
        "pushl %%ebp\n\t"       /* save ebp */
        "movl %%esp,%0\n\t"     /* save esp */
        "movl %2,%%esp\n\t"     /* restore  esp */
        "movl $1f,%1\n\t"       /* 保存当前进程将要执行的指令位置，当进程再次调度到这个进程的时候可以接着上次执行继续执行 */  
 ```
- 改变cpu IP 指向的位置，执行新进程直到完毕
 ```c 
     "pushl %3\n\t" 
     "ret\n\t"               /* restore  eip */
 ```
- 堆栈销毁与旧堆栈的恢复
 ```c
    
      "popl %%ebp\n\t"
 ```


对于运行态切换A到刚加载进来的进程B之间的切换，从[代码](https://github.com/mengning/mykernel/blob/master/myinterrupt.c#L78-L88)看到相比运行态进程间的切换，就多出来一条指令
`"movl %2,%%ebp\n\t" /* restore  ebp */`，其含义是初始B进程的栈基址。也就是说只需要初始化一下栈基址。进程间的切换，这还是一个非常的粗糙，但也基本上整个模型已经建立起来，稍加优化，就非常完美。
