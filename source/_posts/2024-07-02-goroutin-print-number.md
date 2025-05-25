---
title: Golang - N个协程交替打印数字
layout: post
categories:
  - 技术
tags:
  - 并发
  - Golang
date: 2024-07-02 20:39:36
description: 🤝 协同交替打印数字
---

{% note info %}
N个协程交替打印数字，到达一个数值后终止
{% endnote %}

## 网友解法

网上搜索的解法大概如下，网友错别字地方已经修复

{% blockquote %}
启动N个协程，共用一个外部变量计数器，计数器范围是1到100

开启N个`无`缓冲chan，chans[i]塞入数据代表协程i可以进行打印了，打印的数字就是计数器的数

协程i一直阻塞，直到chan[i]通道有数据可以拉，才打印
{% endblockquote %}


## 分析

大思路没有问题，但[具体实现](https://gist.github.com/noname007/6fd0a23920fa115618dbef2504511727?permalink_comment_id=5108543#gistcomment-5108543)的小细节处理上存在两个问题。

- N 为 1 的时候存在死锁问题
- 程序运行完后，协程没有回收，这个比较严重。
  - 首先，破坏了`谁申请、谁释放`资源管理的基本设计原则
  - 其次，常驻内存运行时如果经常被其他协程调用，应用有 OOM 的风险。

只能作为一次性脚本调用，运行结束后整个进程被操作系统回收。针对两个问题做如下修正:

```go
package main

import (
    "fmt"
    "sync"
)



var counter = 0

const CounterMaxValue = 100

func DoJob(GoRoutineNum int) {

    //用于控制业务逻辑
    sigChannel := make([]chan struct{}, GoRoutineNum)
    //用于控制协成是否终结
    quitSigChannel := make([]chan struct{}, GoRoutineNum)

    for i := 0; i < (GoRoutineNum); i++ {
        sigChannel[i] = make(chan struct{})
        quitSigChannel[i] = make(chan struct{})
    }

    mainRoutine := make(chan struct{})

    wg := sync.WaitGroup{}

    for i := 0; i < GoRoutineNum; i++ {
        wg.Add(1)
        go func(idx int) {
            defer wg.Done()
            //FOR:
            for {
                select {
                case <-quitSigChannel[idx]:
                    //break FOR
                    goto END
                case <-sigChannel[idx]:
                    fmt.Printf("goroutine-num:%d %d\n", idx, counter)
                    counter += 1
                    mainRoutine <- struct{}{}
                }

            }
        END:
            fmt.Printf("goroutine-num:%d end\n", idx)
        }(i)
    }

    wg.Add(1)

    go func() {
        wg.Done()

        for i := 0; i < CounterMaxValue; i++ {
            //<-mainRoutine
            sigChannel[i%GoRoutineNum] <- struct{}{}
            <-mainRoutine
        }

        ////使最后一个任务处理协成，进入信号等待状态
        //<-mainRoutine

        for i := 0; i < GoRoutineNum; i++ {
            quitSigChannel[i] <- struct{}{}
        }
    }()

    //mainRoutine <- struct{}{}
    wg.Wait()
}

func main() {
    DoJob(10)
}
```
