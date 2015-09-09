title: lua
tags: 
- lua
---

##函数
- 函数调用时，当实参只有一个table构造式时，圆括号可以省略
- 函数为第一类值，即函数与其他传统类型的值具有相同的权利，函数可以存储到变量中，或者table，作为实参传给函数，作为函数返回值
- `词法域`（`Lexical Scoping`）一个函数可以嵌套在另一个函数中，访问外部函数中的变量，从而使lua能够应用`函数式语言`（fp）中的强大编程技术
- 函数是匿名的，讨论一个函数名时，实际上讨论的是一个持有某函数的变量
- 尾调用 --- 状态机 --- 形式必须为 `return funcname(arg...)`去掉`return`则不是尾调用


**应用**
计算器

迷宫游戏 状态机
数据驱动

##迭代器与泛型

- 迭代器函数、恒定状态、控制变量
- 无状态迭代器 自身不保存任何状态的迭代器，仅仅根据恒定状态、控制变量调用迭代器函数，返回下一个元素
- ipairs 遍历数组，pairs 遍历 table
- 迭代器、生成器



##编译、执行、错误
- 错误处理，异常 pcall
- 

**pcall**
    
    status,result = pcall(function)

result function 执行返回的结果，或者是异常信息

**xpcall**
**debug.debug**
**debug.backtrace**

##第九章 协程
table: coroutine

@thread 挂起状态 coroutine.create(function)
挂起、运行、死亡、正常
协程状态 coroutine.status(@thread)
启动、再次启动 协程 coroutine.resume(@thread)

**应用**
管道与过滤器

##第十章
马尔可夫链


##第十三章 元表 元方法
元表 -- 可以修改一个值的行为，使其在面对一个非预定义的操作的时候执行一个指定的操作

每一个值都有一个元表。table和userdata可以有各自独立的元表，其他类型的值则共享其类型所属的单一元表

lua代码中，只能设置table的元表。若设置其他类型的值的元表，则必须通过c代码来完成


###算数类元方法
- __add
- __sub
- __mul
- __div
- __unm(相反数)
- __mod
- __pow
- __concat (..) 连接操作符

###关系类元方法
- __eq 等于
- __lt 小于
- __gt 大于

###库定义元方法
- __metatable 保护作用
- __tostring  字符串化
 

###table 访问元方法

{% blockquote %}

lua提供了可以改变table行为的方法。有两种可以改变的table行为：
- 查询table 
- 修改table中不存在的字段

{% endblockquote %}

- __index 元方法不一定是一个函数，可以是一个table
    + 当为table时，lua就以相同的方式重新访问这个table， 可用于单一继承
    + 当为方法时，原型为 __index(table,key)  ，可用来实现多重继承、缓存、及其他一些功能

- __newindex 若值为一个function则， 当对table表中的元素赋值的时候，如果索引不存在则调用此方法。若为表，则直接使用相同的索引来索引这个表。

 {% gist d8a6a718832b4d40d3d8 %}


**应用**
 - 更改table表每个元素的默认值
 - 跟踪table元素的访问
 - 构造一个只读的table

有点和php里面的`__get` 和`__set`类似
{% gist 66e3250fde2e40392a40 %}








