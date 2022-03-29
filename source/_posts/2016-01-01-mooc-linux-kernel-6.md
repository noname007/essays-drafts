---
title: Linux 内核分析 -- 进程的创建 
layout: post
tags:
  - mooc
  - 笔记
  - Linux 内核分析
  - 汇编
  - C
description: '杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about'
date: 2016-04-01 20:20:46
---




- 阅读理解task_struct数据结构http://codelab.shiyanlou.com/xref/linux-3.18.6/include/linux/sched.h#1235；
- 分析fork函数对应的内核处理过程sys_clone，理解创建一个新进程如何创建和修改task_struct数据结构；
- 使用gdb跟踪分析一个fork系统调用内核处理函数sys_clone ，验证您对Linux系统创建一个新进程的理解,推荐在实验楼Linux虚拟机环境下完成实验。 特别关注新进程是从哪里开始执行的？为什么从那里能顺利执行下去？即执行起点与内核堆栈如何保证一致。
- 根据本周所学知识分析fork函数对应的系统调用处理过程，撰写一篇署名博客，并在博客文章中注明“真实姓名（与最后申请证书的姓名务必一致） + 原创作品转载请注明出处 + 《Linux内核分析》MOOC课程http://mooc.study.163.com/course/USTC-1000029000 ”，博客内容的具体要求如下：
    + 题目自拟，内容围绕对Linux系统如何创建一个新进程进行；
    + 可以结合实验截图、绘制堆栈状态执行流程图等；
    + 博客内容中需要仔细分析新进程的执行起点及对应的堆栈状态等。
    + 总结部分需要阐明自己对“Linux系统创建一个新进程”的理解

## 进程简介

进程是处于执行期的程序以及它所管理的资源（如打开的文件、挂起的信号、进程状态、地址空间等等）的总称。注意，程序并不是进程，实际上两个或多个进程不仅有可能执行同一程序，而且还有可能共享地址空间等资源。Linux内核通过一个被称为进程描述符的task_struct结构体来管理进程，这个结构体包含了一个进程所需的所有信息[^ref1]。

## `task_struct`代码分析

### 进程状态

```C
//行号   结构成员
1236	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
```
进程的状态，可能取值大概十种，和其他一些相关操作宏　具体参见 [github 代码](https://github.com/torvalds/linux/blob/v3.18-rc6/include/linux/sched.h#L193-L249)，　每种状态的具体含义可以查阅参考资料[^ref1]　
### 进程内核堆栈

```C
1237	void *stack;
```

分配给进程的内核堆栈，分配和释放对应的函数为`alloc_thread_info`, `free_thread_info`



### 进程标志
```C
    unsigned int flags; /* per process flags, defined below */  
```
进程标记，其所有可能取值参见　[github 上linux代码](https://github.com/torvalds/linux/blob/v3.18-rc6/include/linux/sched.h#L1898-L1927),其部分取值含义如下

```C
 /*
 
flags是进程当前的状态标志，具体的如：
 
0x00000002表示进程正在被创建；
 
0x00000004表示进程正准备退出；
 
0x00000040 表示此进程被fork出，但是并没有执行exec；
 
0x00000400表示此进程由于其他进程发送相关信号而被杀死 。
 
*/
```

### 进程间关系

```C
1337	/*
1338	 * pointers to (original) parent process, youngest child, younger sibling,
1339	 * older sibling, respectively.  (p->father can be replaced with
1340	 * p->real_parent->pid)
1341	 */
1342	struct task_struct __rcu *real_parent; /* real parent process */
1343	struct task_struct __rcu *parent; /* recipient of SIGCHLD, wait4() reports */
1344	/*
1345	 * children/sibling forms the list of my natural children
1346	 */
1347	struct list_head children;	/* list of my children */
1348	struct list_head sibling;	/* linkage in my parent's children list */
1349	struct task_struct *group_leader;	/* threadgroup leader */
```

描述进程见关系的一组属性，像父子，兄弟，组



### 进程调度

```C
1253	int prio, static_prio, normal_prio;
1254	unsigned int rt_priority;
1255	const struct sched_class *sched_class;
1256	struct sched_entity se;
1257	struct sched_rt_entity rt;
1258#ifdef CONFIG_CGROUP_SCHED
1259	struct task_group *sched_task_group;
1260#endif
1261	struct sched_dl_entity dl;
1262
1263#ifdef CONFIG_PREEMPT_NOTIFIERS
1264	/* list of struct preempt_notifier: */
1265	struct hlist_head preempt_notifiers;
1266#endif
1267
1268#ifdef CONFIG_BLK_DEV_IO_TRACE
1269	unsigned int btrace_seq;
1270#endif
1271
1272	unsigned int policy;
1273	int nr_cpus_allowed;
1274	cpumask_t cpus_allowed;

```

|||
|--|--|
|static_prio| 用于保存静态优先级，可以通过nice系统调用来进行修改。|
|rt_priority |用于保存实时优先级。|
|normal_prio |的值取决于静态优先级和调度策略。|
|prio |用于保存动态优先级。|
|policy | 表示进程的调度策略，目前主要有五种[^ref1]|
|struct files_structf \* files | 系统打开文件[^ref5] |


其他的还有一些代码介绍可以参考文档[^ref1][^ref2]

## 创建一个新进程在内核中的执行过程
一个用户程序进行fork进程代码样例如下所示：
```C
int Fork(int argc,char*argv[])
{                          
        int pid;           
        pid = fork();      
        if(pid<0)          
        {                  
                fprintf(stderr,"ForkFailed");
                           
        }else if(pid == 0){ 
                printf("this is child process pid:%d\n",getpid());
        }else{             
                printf("this is Parent Process! pid:%d child pid:%d\n",getpid(),pid);
                wait(NULL);
                printf("Child Complete\n");
        }                  
}
```

上述代码运行的模型大致如下：

+ 使用fork、vfork、clone 三个系统调用创建一个新进程，最终都是调用do_fork完成进程的创建
+ 复制父进程
	- 复制一个PCB 即`task_struct  err = arch_dup_task_struct(tsk, orig);`
	- 分配新的内核堆栈
	```C
	ti = alloc_thread_info_node(tsk, node);

	tsk->stack = ti;

	setup_thread_stack(tsk, orig); //这里只是复制thread_info，而非复制内核堆栈
	```
	- 修改复制复制过来的PCB数据，如pid,进程链表，见`copy_process`函数

+ 父子进程运行 
    从用户的代码来看函数`fork`返回了两次，即在父子进程中各返回一次，父进程从系统调用中返回比较容易理解。子进程从系统调用中返回，继续从`fork`处执行，Linux是如何做到的呢？这就涉及子进程的`内核堆栈数据状态`和`task_struct`中`thread`记录的`sp`和`ip`的一致性问题，这是在哪里设定的？copy_thread in copy_process
```C
*childregs = *current_pt_regs(); //复制内核堆栈

childregs->ax = 0; //为什么子进程的fork返回0，这里就是原因！

p->thread.sp = (unsigned long) childregs; //调度到子进程时的内核栈顶

p->thread.ip = (unsigned long) ret_from_fork; //调度到子进程时的第一条指令地址
```

## gdb　跟踪调试程序

程序调用顺序如下所示以缩进格式表示：


```shell

- sys_fork
 - do_fork -- 系统内核调用
  - copy_process -- 复制父进程的所有信息给子进程
   - dup_task_struct　-- 复制父进程PCB信息。
     + alloc_thread_info_node　　-- 分配进程内核堆栈
     + arch_dup_task_struct　　　　-- 直接父子进程共享，写时复制
   - sched_fork -- 把新进程设置为 TASK_RUNNING 
   - copy_thread　-- 　把父进程的寄存器上下文复制给子进程
   - ret_from_fork  -- 设置子进程开始执行的位置

```


### gdb调试——断点相关一些指令 [^ref4]


|||
|--|--|
|b/break|设置断点|
|info breakpoints| 查看当前设置的断点信息|
|disable|断点无效，单还是存在|
|enable|断点有效，这两个属于使能指令|
|clear/delete|两条指令有点不同，delete 更凶猛一些|
|print|打印变量或表达式当前的值|
|whatis|显示某个变量或表达式值的数据类型|
| set variable 变量=值 |给变量赋值,以上命令参考 [^ref4]|
|save breakpoint |保存设置的断点到文件,读取断点设置在启动gdb的时候使用`-x`选项指定断点设置文件[^ref3]|
|help|帮助，可用于查询指令的详细用法|


调试中设置的一些断点，并导出到[文件](/attach.d/fork.bp)
```shell
break sys_clone
break do_fork
break copy_process
break dup_task_struct
break alloc_thread_info_node
break arch_dup_task_struct
break copy_thread
```

## 嵌入到MenuOs,gdb运行调试遇到的问题
1. 执行fork后，进程停止在了子进程，如何发现的呢？利用上次系统调用作业`getpid()`查看进程pid发现的。
2. gdb 无法加载进去符号表，还没找到好的解决方法 
　原来编译的时候配置有问题，没办法进行跟踪调试，根据第二节的课程文档重新编译了一遍就OK了。根据文档制作了一个[Makefile](/attach.d/moocOsEnvBuild.makefile)，下载到一个新文件夹执行

```shell
wget http://blog.soul11201.com/attach.d/moocOsEnvBuild.makefile && make -f moocOsEnvBuild.makefile install
```

确保terminal窗口大小大于`80*19`,并且会弹出来一个窗口记得开启下列选项

```shell
	kernel hacking—>Compile.....
	[*] compile the kernel with debug info
```

等待编译完成，进入menu文件夹执行`make qemu`直接启动MenuOs或者`make qemu-gdb`启动MenuOs并且使用gdb跟踪调试

[^ref1]: http://blog.csdn.net/npy_lp/article/details/7292563
[^ref2]: http://www.2cto.com/os/201201/116810.html
[^ref3]: http://jingyan.baidu.com/article/f3ad7d0fff191509c3345bd1.html
[^ref4]: http://www.cnblogs.com/rosesmall/archive/2012/04/13/2445527.html
[^ref5]: http://www.jianshu.com/p/5ffdd11a93cd

