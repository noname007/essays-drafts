---
title: Linux 内核分析 -- C函数调用栈机制在汇编中的实现
layout: post
date: 2016-02-24 07:55:28
tags:
- mooc 
- 笔记
- Linux 内核分析
- 汇编
- C
toc: true
description: 杨振振  原创作品转载请注明出处  《Linux内核分析》MOOC课程 http://www.xuetangx.com/courses/course-v1:ustcX+USTC001+_/about
---

## 一些常识

平时可能见到movb,movw,movl等一些指令，三条指令的意思基本一样，不一样的地方在于，操作的数据是1个字节(1B)，1个字(2B)，1个双字（4B）。

## 基础知识
汇编语言简单的可以认为是机器语言的一种便记符号，理解体系结构对理解汇编指令集大有裨益。现在的流行计算机体系结构是冯诺依曼体系也即存储程序体系。其结构大致如下:

![](/imgs/cpu-arch.jpg)

也决定了指令集设计基本上都是围绕着cpu、存储进行设计的，对于汇编的语法格式，Intel和AT&T汇编之间的区别看以参考文档 [Linux 汇编语言开发指南](http://www.ibm.com/developerworks/cn/linux/l-assembly/),这里简要的说一下本文代码中用到的AT&T 32位cpu汇编语言的一些指令。<!-- 说到汇编语言，就离不开了解一点cpu硬件结构的知识， -->汇编中用到的cpu硬件主要是寄存器，它们可用来暂存`指令`、`数据`和`地址`，这里主要用到的寄存器包括通用寄存器中的eax，以及esp（栈顶指针寄存器），ebp（占地指针寄存器）。另外还有一些操作指令，像pushl，popl，movl，leave、enter：

|指令|含义|等价指令|
|-----|-----|---|
|pushl| 入栈指令|
|popl | 出栈指令|
|movl |a,b 数据传送指令,把a--->b|
|leave|跟函数调用相关 |`movl   %ebp, %esp `<br/>`popl   %ebp`|
|enter|跟函数调用相关 |`pushl   %ebp`<br/>`movl    %esp, %ebp`|

## 一段代码

首先我们分析一段代码，每个函数都不接受参数。重点分析`f()`的汇编代码。其他不相关的干扰信息少。
```C 
int g(){
    return 4;

}
int f(){
    return g() + 2;
}
int main(){

    return f() + 1;
}


```

使用 `gcc -S -o main.s mian.c -m32`指令编译过后，删除了跟链接相关的信息过后的汇编代码。

```gas
_g:
    pushl   %ebp
    movl    %esp, %ebp
    movl    $4, %eax
    popl    %ebp
    ret
_f:
    pushl   %ebp
    movl    %esp, %ebp
    call    _g
    addl    $2, %eax
    popl    %ebp
    ret
_main:
    pushl   %ebp
    movl    %esp, %ebp
    call    _f
    addl    $1, %eax
    leave
    ret
```

俗话说射人先射马，擒贼先擒王，看上面这坨代码，如果不知道模型是什么确实挺费劲，下面就个人理解说一下这个模型。比如说我们把64KB这么大内存空间分配给`_f`使用，初始化的时候，EBP，ESP所指向如图所示的上一个函数的栈基址和栈顶地址。当在f中执行完下面的指令后，ESP,EBP位置如下图所示：

```gas
pushl   %ebp
movl    %esp, %ebp
```

![](/imgs/stack-asm.png)

从图中也就看到，当前函数使用的栈内存为[ESP,EBP)（不是固定的哦，因为，ESP会变化）这段内存空间（它俩指向同一个位置说明函数栈还没有使用），另外[EBP,EBP+4)这段内存空间保存的是调用此函数的函数栈基址。
在到`popl    %ebp`这条指令之间没有单向操作栈的指令，故可以略去不用考虑，直接看这条指令，此时已经是函数调用完毕，此函数中保存的调用此函数的函数栈机制恢复到ebp寄存器中，到此函数调用栈的建立与销毁已经完毕。再看_g的代码，就会发现同样也是利用这个模型机制，到此内存中程序的函数调用栈机制的整体模型浮现在了面前。至于参数怎么传的，返回值怎么保存的，简单的说在栈和ax寄存器或者内存中，后面再详细说。


