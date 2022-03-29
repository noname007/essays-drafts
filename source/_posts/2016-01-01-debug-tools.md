---
title: 调试工具
layout: post
tags: 
- gdb
- 工具
date: 2015-09-23 18:22:00
---

## ☆ gdb
启动gdb后

|参数|含义|
|-----|---|
|b/breakpoint | 断点
|p print    | 打印输出变量|
|r ||
|attach||
|watch||
|c||
|bt||
|up||
|list||
|info macro| 例 info macro NGX_OK|
|macro expand||


## ☆ ulimit
-c 
unlimited

## ☆ tcpdump

|选项|含义|
|---|---|
|t| 时间戳|
|x|十六进制显示数据包|
|X|十六进制显示数据包,同时会对应显示对应的ASCII码表|
|i|后跟网卡名字，如`eth0`|
|src|源地址|
|dst|目标地址|
|and|逻辑与|
|or |逻辑或|

`tcpdump  -i eth0 -Xnt "(src 192.168.1.194 and dst 192.168.1.183) or (src 192.168.1.183 and dst 192.168.1.194)"`
