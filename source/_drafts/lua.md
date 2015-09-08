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



