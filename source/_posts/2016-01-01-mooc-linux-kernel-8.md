---
title: Linux 内核分析 -- 进程调度实现原理简单分析
layout: post
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-04-11 16:36:07
---


<!-- 理解Linux系统中进程调度的时机，可以在内核代码中搜索schedule()函数，看都是哪里调用了schedule()，判断我们课程内容中的总结是否准确；
使用gdb跟踪分析一个schedule()函数 ，验证您对Linux系统进程调度与进程切换过程的理解；推荐在实验楼Linux虚拟机环境下完成实验。
特别关注并仔细分析switch_to中的汇编代码，理解进程上下文的切换机制，以及与中断上下文切换的关系；
根据本周所学知识分析并理解Linux中进程调度与进程切换过程，
 -->

## 进程调度时机 -- `schedule()`

所有可能执行调度的时间点:

- 主动调度
    + 中断处理过程（包括时钟中断、I/O中断、系统调用和异常）中，直接调用schedule()，或者返回用户态时根据need_resched标记调用schedule()；
    + 内核线程可以直接调用schedule()进行进程切换，也可以在中断处理过程中进行调度，也就是说内核线程作为一类的特殊的进程可以主动调度，也可以被动调度；
- 被动调度
    + 用户态进程无法实现主动调度，仅能通过陷入内核态后的某个时机点进行调度，即在中断处理过程中进行调度。

>>总的来说，发生`中断`或者在`内核线程`中时才会出现进程调度调度，调用 [`schedule()`](http://codelab.shiyanlou.com/xref/linux-3.18.6/kernel/sched/core.c#2865)。

调用顺序

- `schedule()`
`schedule()`函数调用`pick_next_task`选择一个新的进程来运行，并调用`context_switch`完成进程上下文的切换。`context_switch`靠调用`switch_to`这个宏来进行关键上下文切换

`next = pick_next_task(rq, prev);//进程调度算法都封装这个函数内部,选择出来下一个将要执行的进程`
[`context_switch(rq, prev, next);//进程上下文切换` ](http://codelab.shiyanlou.com/xref/linux-3.18.6/kernel/sched/core.c#2834)
[`switch_to`](https://github.com/noname007/linux/blob/v3.18-rc6/arch/x86/include/asm/switch_to.h#L27-L77) 利用了prev和next两个参数：prev指向当前进程，next指向被调度的进程


```c 
/*
 * Saving eflags is important. It switches not only IOPL between tasks,
 * it also protects other tasks from NT leaking through sysenter etc.
 */
#define switch_to(prev, next, last)                 \
do {                                    \
    /*                              \
     * Context-switching clobbers all registers, so we clobber  \
     * them explicitly, via unused output variables.        \
     * (EAX and EBP is not listed because EBP is saved/restored \
     * explicitly for wchan access and EAX is the return value of   \
     * __switch_to())                       \
     */                             \
    unsigned long ebx, ecx, edx, esi, edi;              \
                                    \
    asm volatile("pushfl\n\t"       /* save    flags */ \
             "pushl %%ebp\n\t"      /* save    EBP   */ \
             "movl %%esp,%[prev_sp]\n\t"    /* save    ESP   */ \
             "movl %[next_sp],%%esp\n\t"    /* restore ESP   */ \
             "movl $1f,%[prev_ip]\n\t"  /* save    EIP   */ \
             "pushl %[next_ip]\n\t" /* restore EIP   */ \
             __switch_canary                    \
             "jmp __switch_to\n"    /* regparm call  */ \
             "1:\t"                     \
             "popl %%ebp\n\t"       /* restore EBP   */ \
             "popfl\n"          /* restore flags */ \
                                    \
             /* output parameters */                \
             : [prev_sp] "=m" (prev->thread.sp),        \
               [prev_ip] "=m" (prev->thread.ip),        \
               "=a" (last),                 \
                                    \
               /* clobbered output registers: */        \
               "=b" (ebx), "=c" (ecx), "=d" (edx),      \
               "=S" (esi), "=D" (edi)               \
                                        \
               __switch_canary_oparam               \
                                    \
               /* input parameters: */              \
             : [next_sp]  "m" (next->thread.sp),        \
               [next_ip]  "m" (next->thread.ip),        \
                                        \
               /* regparm parameters for __switch_to(): */  \
               [prev]     "a" (prev),               \
               [next]     "d" (next)                \
                                    \
               __switch_canary_iparam               \
                                    \
             : /* reloaded segment registers */         \
            "memory");                  \
} while (0)
```

只将汇编逻辑代码提出来，将前一个进程记做1号进程，后面的记做2号进程

```c
 //保存1号进程的标志寄存器和完成堆栈切换
 "pushfl\n\t"       /* save    flags */ \
 "pushl %%ebp\n\t"      /* save    EBP   */ \
 "movl %%esp,%[prev_sp]\n\t"    /* save    ESP   */ \
 "movl %[next_sp],%%esp\n\t"    /* restore ESP   */ \
 //下次切换到1号执行时，开始执行的位置是$1这个标号位置，将其保存。\
 "movl $1f,%[prev_ip]\n\t"  /* save    EIP   */ \

//切换到2号进程：先将下一个进程开始执行位置保存到栈中，调用__switch_to函数，这样函数执行完毕后执行ret,就将 next_ip 赋给了 eip \
//对于32位x84架构系统 __switch_to 代码在 http://codelab.shiyanlou.com/xref/linux-3.18.6/arch/x86/kernel/process_32.c#218 \
 "pushl %[next_ip]\n\t" /* restore EIP   */ \
 "jmp __switch_to\n"    /* regparm call  */ \

 //下次1号进程切换回来的时候，开始执行的地方
 "1:\t"                     \
 "popl %%ebp\n\t"       /* restore EBP   */ \
 "popfl\n"          /* restore flags */ \
```


<!-- ## gdb跟踪分析 `schedule()` 进程调度与进程切换过程



```

``` -->
<!-- 
## 分析switch_to中的汇编代码 ，进程上下文的切换机制，以及与中断上下文切换的关系 -->
