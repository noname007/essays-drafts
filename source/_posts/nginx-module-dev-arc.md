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

<script src="https://gist.github.com/noname007/2aef05f4698647a7f95a.js"></script>

##[reference]
http://tengine.taobao.org/book/

##[resource]
http://www.evanmiller.org/nginx-modules-guide.html
