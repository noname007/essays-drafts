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
- 基本数据结构
    + 整型和无符号整型
    + 字符串
    + 链表容器
    + 散列表
    + ngx_buf_t -- 处理大数据的关键，应用于内存、磁盘文件数据
    + ngx_chain_t -- 配合 ngx_buf_t 使用的链表数据结构
    + ngx_file_t -- 应用于描述磁盘文件、
- 编译进自己的模块
    + 使用`./configure --add-module=PATH` 
    + 修改`./configure` 脚本执行后生成的 `objs/Makefile` 和 `objs/ngx_modules.c`，文件