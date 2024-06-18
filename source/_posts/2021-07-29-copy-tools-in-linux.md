---
layout: post
title:  redis-cli 
date:   2021-07-29 15:53:45 +0800
categories:
- [技术,Shell]
tags:
- Linux
description: 在不同的 Linux 主机间共享二进制可执行文件
---

把一台机器上的redis-cli 拷贝到另外一台机器上并使用：

```bash
rsync -avz root@10.23.27.2:/usr/bin/redis-cli .

./redis-cli

ldd `which redis-cli`

rsync -avz root@10.23.27.2:/lib64/libjemalloc.so.1 .

export LD_LIBRARY_PATH=`pwd`

redis-cli
```
