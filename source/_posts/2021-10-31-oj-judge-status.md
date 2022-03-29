---
layout: post
title: OJ常见的Judge Status
date:   2013-02-27 10:33:06 +0800
---

Queuing : 提交太多了，OJ无法在第一时间给所有提交以评判结果，后面提交的程序将暂时处于排队状态等待OJ的评判。不过这个过程一般不会很长。
 
Compiling : 您提交的代码正在被编译。
 
Running : 您的程序正在OJ上运行。
 
Judging : OJ正在检查您程序的输出是否正确。
 
Accepted (AC) : 您的程序是正确的，恭喜！
 
Presentation Error (PE) : 虽然您的程序貌似输出了正确的结果，但是这个结果的格式有点问题。请检查程序的输出是否多了或者少了空格（' '）、制表符（'\t'）或者换行符（'\n'）。
 
Wrong Answer (WA) : 输出结果错，这个一般认为是算法有问题。
 
Runtime Error (RE) : 运行时错误，这个一般是程序在运行期间执行了非法的操作造成的。以下列出常见的错误类型：
 
ACCESS_VIOLATION 您的程序想从一些非法的地址空间读取或向其中写入内容。一般例如指针、数组下标越界都会造成这个错误的。
ARRAY_BOUNDS_EXCEEDED 您的程序试图访问一个超出硬件支持范围的数组单元。
FLOAT_DENORMAL_OPERAND 进行了一个非正常的浮点操作。一般是由于一个非正常的浮点数参与了浮点操作所引起的，比如这个数的浮点格式不正确。
FLOAT_DIVIDE_BY_ZERO 浮点数除法出现除数为零的异常。
FLOAT_OVERFLOW 浮点溢出。要表示的数太大，超出了浮点数的表示范围。
FLOAT_UNDERFLOW 浮点下溢。要表示的数太小，超出了浮点数的表示范围。
INTEGER_DIVIDE_BY_ZERO 在进行整数除法的时候出现了除数为零的异常。
INTEGER_OVERFLOW 整数溢出。要表示的数值太大，超出了整数变量的范围。
STACK_OVERFLOW 栈溢出。一般是由于无限递归或者在函数里使用了太大的数组变量的原因。
...... 其他错误，包括C++标准库/STL运行时库错误等，这里不再举例。
 
Time Limit Exceeded (TLE) : 您的程序运行的时间已经超出了这个题目的时间限制。
 
Memory Limit Exceeded (MLE) : 您的程序运行的内存已经超出了这个题目的内存限制。
 
Output Limit Exceeded (OLE) : 您的程序输出内容太多，超过了这个题目的输出限制。
 
Compilation Error (CE) : 您的程序语法有问题，编译器无法编译。具体的出错信息可以点击链接察看。
 
System Error (SE) : OJ内部出现错误。由于我们的OJ可能存在一些小问题，所以出现这个信息请原谅，同时请及时与管理员联系。
 
Out Of Contest Time : 超出比赛时间，这个信息只有在比赛的时候才会出现。
