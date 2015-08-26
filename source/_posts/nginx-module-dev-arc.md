title: nginx模块开发与架构解析
date: 2015-08-20 18:00:44
tags:
- 读书笔记
- 摘抄
- nginx
- c
---
#第一、二章
##环境依赖

##内核参数配置

##编译安装中的config选项

##操作系统信号与nginx命令

##2.3 Nginx 服务的基本配置

###用于调试、定位问题的配置项
  
- daemon on|off
- master_process on|off
- error_log /path/file level
  + lever : debug --> info --> notice --> warn --> error --> crit -->alert -->emerg
  + 当为debug级别的日志的时候 需加入 `--with-debug` 编译选项
- debug_points [stop|abort]
- debug_connection [ip|CIDR] 针对ip|CIDR地址的才开启debug 级别的调试
- worker_rlimit_core size; 限制coredump文件大小
- working_directory path   配置coredump 文件所放置的目录
- 



#第三章 
-  nginx 调用http 模块的整个运行时流程
-  把模块编译进nginx前的准备工作    
    + 模块命名规则
    + 运行时常见的调用方式
- nginx基本数据结构
    + 整型和无符号整型
    + 字符串
    + 链表容器
    + 散列表
    + ngx_buf_t -- 处理大数据的关键，应用于内存、磁盘文件数据
    + ngx_chain_t -- 配合 ngx_buf_t 使用的链表数据结构
    + ngx_file_t -- 应用于描述磁盘文件、
    + ngx_module_t nginx模块的数据结构
- 编译进自己的模块
    + 使用`./configure --add-module=PATH` 
    + 修改`./configure` 脚本执行后生成的 `objs/Makefile` 和 `objs/ngx_modules.c`，文件
- http模块数据结构
 定义模块时最重要的是设置ctx 和 commands 两个成员
 ngx_http_module_t  ---- http 框架 重载、读取配置文时，在其中描述了执行的8个阶段
  -- 读取配置文件前后
  -- main 级别配置
  -- loc 级别配置
  -- server 级别配置
  -- 合并冲突配置
  + `ngx_command_t` 定义模块配置文件参数 配置里面的命令与对应程序回调函数的一个映射表
  + `ngx_null_command`
  + `ngx_http_request_t` http 请求信息，方法，URI,协议号，版本号头部等
##命名习惯
- 模块配置信息 -- `ngx_http_<module name>_(main|srv|loc)_conf_t`
- 模块配置指令 -- `ngx_command_t `


##[总结]
###nginx 加载http模块的流程

根据 `ngx_module_t `类型的变量，

- 设置模块的类型，
- 设置模块的运行上下文环境相关的回调函数、
- 根据 `ngx_command_t`类型的变量中的配置，设置nginx配置文件中的`指令`和`回调程序`之间的`映射`关系、

-----`ngx_module_t`
     |-->`ngx_command_t`
     |-->


##跟踪调试
1. 绑定Nginx到gdb
  - 编译时添加 `-g`选项,不加则会因为缺少相应的符号信息，可能会有“No symbol table is loaded.User the"file" command”
  - 添加`-O0`编译选项，出现下面的现象多半时因为没有添加此选项，gcc优化所致
    + gdb内打印变量时提示“<value optimized out>”
    + gdb显示的当前正执行的代码行与源码匹配不上
  - 编译选项添加
    + objs/Makefile文件，这两个变量直接加在CFLAGS变量里面
    + 执行configure 配置时 (两者都可以)
      * `./configure --with-cc-opt='-g -O0'`
      * `CFLAGS="-g -O0" ./configure`
    + 执行make命令时
      * `make CFLAGS="-g -O0"`
2. gdb调试
  - `-p` 指定要调试的进程的pid,`(gdb)attach pid`
  - `w`
  - `b`
  - `r`
  - 'p'
  - 'bt'
  - 'c'
  - `info macro NGX_OK`
  - `macro expand NGX_OK`
  - `list`
2. nginx 日志系统 ngx_log_xxx( );
3.  


##第四章

1. 如何解析配置文件


所谓的http框架主要包括ngx_http_module 和ngx_http_core_module




##[reference]
http://tengine.taobao.org/book/

##[resource]
http://www.evanmiller.org/nginx-modules-guide.html

[tools]

SystemTap 监控和跟踪运行中的 Linux 内核的操作的动态方法
http://www.ibm.com/developerworks/cn/linux/l-systemtap/

Sublime插件：C语言篇
http://www.jianshu.com/p/595975a2a5f3

使用Sublime Text3+Ctags+Cscope替代Source Insight
https://www.zybuluo.com/lanxinyuchs/note/33551