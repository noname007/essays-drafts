title: nginx 笔记摘要
tags: 
date: 2015-09-06 00:00:00
---
##nginx 变量
Nginx 变量的创建和赋值操作发生在全然不同的时间阶段。Nginx 变量的创建只能发生在 Nginx 配置加载的时候，或者说 Nginx 启动的时候；而赋值操作则只会发生在请求实际处理的时候。这意味着不创建而直接使用变量会导致启动失败，同时也意味着我们无法在请求处理时动态地创建新的 Nginx 变量。

Nginx 变量一旦创建，其变量名的可见范围就是整个 Nginx 配置，甚至可以跨越不同虚拟主机的 server 配置块

Nginx 变量的生命期是不可能跨越请求边界的。

所谓“内部跳转”，就是在处理请求的过程中，于服务器内部，从一个 location 跳转到另一个 location 的过程

Nginx 变量值容器的生命期是与当前正在处理的请求绑定的

惰性求职

getter setter 特性

计算缓存


内建变量都不是简单的“存放值的容器”，它们一般会通过注册“存取处理程序”来表现得与众不同

父子请求间的变量共享会导致一些奇怪的问题

Nginx 变量的值只有一种类型，那就是字符串，但是变量也有可能压根就不存在有意义的值。没有值的变量也有两种特殊的值：一种是“不合法”（invalid），另一种是“没找到”（not found）。

##Nginx 配置指令的执行顺序




##ref resource
https://openresty.org/download/agentzh-nginx-tutorials-zhcn.html