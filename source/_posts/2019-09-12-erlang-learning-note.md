---
layout: post
title:  Erlang 学习笔记
date:   2019-09-12 20:22:36 +0800
categories: [notes]
tags: [erlang,笔记]
published: true
---


#### 作者 Joe Armstrong(27 December 1950 – 20 April 2019)'s blog 
- https://joearms.github.io
- http://armstrongonsoftware.blogspot.com

#### 资料

- [Erlang 编程语言  第二版](https://erldoc.com/doc/pdf/Erlang%E7%A8%8B%E5%BA%8F%E8%AE%BE%E8%AE%A1(%E7%AC%AC2%E7%89%88).pdf)
- [Erlang  编程语言 第二版 书籍源码](https://github.com/noname007/erlang-programming-e2)
- [Erlang/OTP 中文手册](https://erldoc.com/)


#### Basic

> hello.erl

```erlang
-module(hello).
-export([start/0]).

start() ->
    io:format("Hello world~n").
	
```

- erl shell

```
$ erl
Erlang/OTP 22 [erts-10.4.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Eshell V10.4.4  (abort with ^G)
1>

```
- `=` 模式匹配
  
   test & bind
   
   `f()`释放所有绑定 

- 模块

	扩展名为 .erl 的文件

- 编译
	
	erlang shell
	> 1\> c(module_name)
	
	shell 
	>$ erlc hello.erl


-  运行
   
	erlang shell
	> 2\> hello:start()
	
	shell 
	>$ erl -noshell -s hello start -s init stop

- 进程

	> 3\> Pid = spawn(hello,start,[]).

- self()

	获取当前进程的 Pid
	
- !
	 
	 往进程信箱投递消息
	 > 5\>  Pid ! "hello".
- receive

	```erlang
	loop(Dir) ->
		receive
			{Client, list_dir} ->
				Client ! {self(), file:list_dir(Dir)};
			{Client, {get_file, File}} ->
				Full = filename:join(Dir, File),
				Client ! {self(), file:read_file(Full)}
		end,
		loop(Dir).
	```
	
	
	作者利用分布式的 Erlang  节点 实现一个文件传输服务器: [ 为什么我经常从零开始实现一个东西](http://armstrongonsoftware.blogspot.com/2006/09/why-i-often-implement-things-from.html)


- erl shell 中的快捷键

	 C-c 
	 C-g

- 变量

	大写字母开头
	
	一次性赋值 -->  无可变状态 -->  无共享内存 --> 无锁
	
	模式匹配、变量绑定

- / div rem

	5/2 --> 2.5  浮点数
	
	5 div 2 --> 2
	
	5 rem 2 --> 1
	
-  浮点数

	Erlang在内部使用64位的IEEE 754-1985浮点数

- 原子

	全局
	
	小写字母开头
	
	单引号内大写字母开头或非字母数字外的字符

	Erlang不会垃圾回收（garbage collect）原子

-  元组

	把一些数量固定的项目归组成单一的实体
	
	声明它们时自动创建

	创建 、 析取
	
	```erlang
	15> X = {joe, {name, "joe"}, {age, 69}}.
	X = {joe, {name, "joe"}, {age, 69}}.

	17> {_,{_, Name},{_,Age}} = X.
	{_,{_, Name},{_,Age}} = X.
	{joe,{name,"joe"},{age,69}}

	18> Name.
	Name.
	"joe"

	19> Age.
	Age.
	69

	```
	
-  列表 [head | tail]

	用来存放任意数量的事物
	
	表头 head 一个项目
	
	表尾 tail  也是一个列表
	
	空列表 []
	
	给tail 列表的开头添加不止一个元素 [E1,E2,..,En | tail]
	
	创建、析取
	
	```erlang
	21> T = [X,X,X, 1 + 2, "hello", 2.5, joe, {p,"test"}].
	T = [X,X,X, 1 + 2, "hello", 2.5, joe, {p,"test"}].
	[{joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 3,"hello",2.5,joe,
	 {p,"test"}]
	22> T2 = ["H1","h2", 3 | T].
	T2 = ["H1","h2", 3 | T].
	["H1","h2",3,
	 {joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 3,"hello",2.5,joe,
	 {p,"test"}]

	23> [H1,H2,H3,  {_,{_, Name1},{_,Age1}},  {_,{_, Name2},{_,Age2}} | T3] = T2.
	[H1,H2,H3,  {_,{_, Name1},{_,Age1}},  {_,{_, Name2},{_,Age2}} | T3] = T2.
	["H1","h2",3,
	 {joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 {joe,{name,"joe"},{age,69}},
	 3,"hello",2.5,joe,
	 {p,"test"}]
	24> H1.
	H1.
	"H1"
	25> H2.
	H2.
	"h2"
	26> Name1.
	Name1.
	"joe"
	27> Name2.
	Name2.
	"joe"

	```

-  字符串

	Erlang里没有字符串
	
	表示方法：
		
		整数组成的列表( 每个元素为 unicode codepoint 代码点)
		
		二进制类型
	
		字符串字面量 -- 双引号 围起来的一串字符 "hello" --  列表简写模式
		
	列表内的 所有 整数 都为可打印字符时，打印出来的是字符串字面量，反之为列表
	
	列表表示字符串时，每个整数代表对应的 Unicode  字符,  无穷大字符 -- `"a\x{221e}b"`
	
	格式化输出
		
		- 输出 unicode 字符 erl shell 为 Latin 字符集，回显显示的是整数列表形式
		- 字符串按照列表形式输出
		
	```erlang
		Erlang/OTP 22 [erts-10.4.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

		Eshell V10.4.4  (abort with ^G)
		1>  X2 ="a\x{221e}b".
		[97,8734,98]
		2> io:format("~ts~n",[X2]).
		a∞b
		ok
    
		4> X1 = [97, 98, 99].
		"abc"
		5> X = "abc".
		"abc"
		
		9> io:format("~p~p~n", [X,X1]).
		"abc""abc"
		ok
		10> io:format("~p~w~n", [X,X1]).
		"abc"[97,98,99]
		ok
	```
	
	字符--->整数 `$A %% 96` 
		
- case

- 标点符号 `, ; .`
		
- try
		
- fun 


- 列表推导


- BIF 内置函数 属于 模块 erlang
  http://erlang.org/doc/man/erlang.html
  
- `guard` : `when` : `, ;`  -- erlang  表达式子集


- 记录

  记录其实就是元组的另一种形式，因此它们的存储与性能特性和元组一样
  
  `-record(todo , {status = reminder, who=joe, text})`
  
  `rr("record.hrl")` 读取记录定义
  
   构建
	   直接创建
	   基于旧的创建
   析取
	   模式匹配
  
- 映射

	`#{a => 1, b:2}`
	
	maps模块 操作映射组的内置模块
	
	构建
		直接创建
		基于旧的创建
	析取
		模式匹配

	比较
		
		大小
		按照建的排序，比较键值的大小


	```erlang
	
	2> #{age=>20, name:="yang", friends:=[#{name:="A",age:=21},#{age:=19,name:="B"}]}.
	* 1: only association operators '=>' are allowed in map construction
	3> #{age=>20, name=>"yang", friends=>[#{name=>"A",age=>21},#{age=>19,name => "B"}]}.
	#{age => 20,
	  friends =>
		  [#{age => 21,name => "A"},#{age => 19,name => "B"}],
	  name => "yang"}
	4> X1 = #{age=>20, name=>"yang", friends=>[#{name=>"A",age=>21},#{age=>19,name => "B"}]}.
	#{age => 20,
	  friends =>
		  [#{age => 21,name => "A"},#{age => 19,name => "B"}],
	  name => "yang"}
	5> X2 = X1#{name:="test"}.
	#{age => 20,
	  friends =>
		  [#{age => 21,name => "A"},#{age => 19,name => "B"}],
	  name => "test"}

	6> X1 >X2 .
	true
	7> X1 < X2.
	false
	8> maps:to_list(X1).
	[{age,20},
	 {friends,[#{age => 21,name => "A"},
			   #{age => 19,name => "B"}]},
	 {name,"yang"}]
	9> maps:to_list(X1) > maps:to_list(X2).
	true
	```
	
	黑历史：https://stackoverflow.com/questions/27803001/undefined-function-mapsto-json-1
	
- 异常  错误
	
	-  典型系统内部产生错误： 模式匹配失败
	
		
	- 使用函数主动产生错误
		
		throw(Exception)
	
		exit(Exception)
	
			终止当前进程。 异常未捕获 信号 {'EXIT', Pid, Why}  发送给
		
		error(Exception)

	- let it crash

	
	  在Erlang里，防御式编程是内建的
	  
	  永远不要在函数被错误参数调用时返回一个值，而是要抛出一个异常错误。要假定调用者会修复这个错误。
	  
	  抛错要快而明显，也要文明。
	  
	  立即崩溃是为了不让事情变得更糟。错误消息应当被写入永久性的错误日志，而且要包含足够多的细节，以便过后查明是哪里出了错。错误消息对程序员来说就像是来之不易的砂金，绝不能任由它们随着屏幕滚动而永远消失。
	  
	  程序员才应该能看到程序崩溃时产生的详细错误消息。程序的用户绝对不能看到这些消息。用户应当得到警告，让他们知道有错误发生这一情况，以及可以采取什么措施来弥补错误。
  
	  
-  二进制 binary
   
   位数都会是8的整数倍

	构造
	
	析构
	
	类型转换函数
	
	io 列表
	
	type: iolist -> [ iolist | I:int when 0<= I <= 255 | binary ]
	
	
	```erlang
	2> <<255>>.
	<<"ÿ">>
	3> <<256>>.
	<<0>>
	4> list_to_binary([256]).
	** exception error: bad argument
		in function  list_to_binary/1
			called as list_to_binary([256])
    5> <<256,257,258>>.
	<<0,1,2>>
	6> <<"abc">>.
	<<"abc">>
	7> list_to_binary([255]).
	<<"ÿ">>
	22> X = "\777".
	X = "\777".
	[511]
	
	32> X = 0.58.
	35> <<X/float>>.
	<<X/float>>.
	<<63,226,143,92,40,245,194,143>>

	```
	
	[0.58在内存中的实际数据](https://gist.github.com/noname007/bf25c7f053d164a833ddfd881741d4e0)
	

	-  整数截断
	- list_to_binary 只接受 io 列表
	
	- 实际应用
		解析 IP 协议
		寻找 MPEG 数据里的同步帧
		
	
	
- 位串

	强调数据里的位数不是8的整数倍


- 杂项 programming erlang 2e chapter 8
