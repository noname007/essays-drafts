title: Linux 内核分析 -- 进程的创建 
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
|policy |表示进程的调度策略，目前主要有五种[^ref1]|

[^ref1]: http://blog.csdn.net/npy_lp/article/details/7292563
[^ref2]: http://www.2cto.com/os/201201/116810.html