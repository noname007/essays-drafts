---
title: go help modules
layout: post
tags:
  - 笔记
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2022-04-09 17:20:29
---


![go help modules](/imgs/2022-04-09_17-24.png "a")

## Goland 对 go get 引入的包不能自动提示 ##
有说需要清理缓存重新启动，有说需要 go mod vendor， 但都不起效，加上 `-u` 选项就起效了
`go get -u -x -v pkg_url`
