---
layout: post
title:  Go Sarama Kafka 数据丢失分析
date:   2021-12-23 16:56:36 +0800
tags:
- go
- kafka
---
* 目录
{:toc}

## 背景与过程 ##

维护的一个线上工单同步项目，业务方反馈工单不能同步。线上排查过程简单总结一下。

查看定时任务，没什么问题，每分钟会检测进程是否存活，挂掉的会拉起来，并且每天凌晨也会重启一下进程。

查看进程状态也是在`S`态，运行时间也无异常

日志中有一条如下记录：

```
invalid memory address or nil pointer dereference
exit....
```
很奇怪，日志记录 exit，但是进程却没有退出。

排查源码，结构逻辑类似下面代码样例

```go
package main

import (
	"fmt"
	"github.com/Shopify/sarama"
	"github.com/astaxie/beego/logs"
	cluster "github.com/bsm/sarama-cluster"
	"os"
	"os/signal"
	"runtime/debug"
	"syscall"
)

var (
	cfg struct {
		Kafka struct {
			Addrs  []string
			Group  string
			Topics []string
		}
	}
)

func bussiness_logic(message *sarama.ConsumerMessage) {
	println("pass")
}

func main() {

	go func() {

		defer func() {
			if err := recover(); err != nil {
				fmt.Println(err)
				fmt.Println("exit....")
			}
		}()

		var (
			kafkaConfig   = cluster.NewConfig()
			KafkaConsumer *cluster.Consumer
			err           error
		)

		kafkaConfig.Consumer.Return.Errors = true
		kafkaConfig.Group.Return.Notifications = true

		if KafkaConsumer, err = cluster.NewConsumer(cfg.Kafka.Addrs, cfg.Kafka.Group, cfg.Kafka.Topics, kafkaConfig); err != nil {
			panic(err)
		}

		defer KafkaConsumer.Close()

		var (
			message      *sarama.ConsumerMessage
			notification *cluster.Notification
		)

		for {
			select {
			case message = <-KafkaConsumer.Messages():
				bussiness_logic(message)
			case notification = <-KafkaConsumer.Notifications():
				logs.Info("kafka notification:%v", notification)
			case err = <-KafkaConsumer.Errors():
				logs.Info("kafka error:%v", err)
			}
		}
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c)
	signal.Ignore(syscall.SIGPIPE, syscall.SIGWINCH, syscall.SIGHUP, syscall.SIGURG)

	s := <-c
	fmt.Println(s)
	debug.PrintStack()
}

```


bussiness_logic 出现指针访问异常后，go 协程会被回收，执行 `defer` 语句。问题出在了这里，记录完日志后，没调用`os.Exit(1)`


```go
        defer func() {
			if err := recover(); err != nil {
				fmt.Println(err)
				fmt.Println("exit....")
			}
		}()
```

## 消息为什么会丢失？ ##


![](/assets/go-sarama.consumer-3.png)

- 协程 hbloop： 间隔一段时间向broker发送心跳的
- 协程 parseResponse,responseFeeder：会将获取到的 kafka 批量消息存到内存 `[]*ConsumerMmessage{}` 中,并通过管道 `chan *ConsumerMmessage` 发送出去，应用程序从而能一条一条的消费

### 原因 ###

应用程序在消费其中一条数据时，业务处理逻辑处理出现内存异常，协程退出，系统回收。内存中剩余未消费的消息旧在哪里一直不会被消费，等到进程通过信号终止时，这些消息被丢弃


## 同类问题 demo ##

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {

	var f func()

	c := make(chan int)
	d := make(chan int)
	wg := sync.WaitGroup{}
	wg.Add(1)
    
	f = func() {
		defer func() {
			if err := recover(); err != nil {
				fmt.Println(err)
				fmt.Println("exit....")
			}
		}()

		for data := range d {
			fmt.Printf("cosume %d\n ", data)

			var i *int
			*i = 1
			fmt.Println(i, &i, *i)
		}

	}

	go f()

	go func() {
		for {
			print("-\n")
			select {
			case x, _ := <-c:
				d <- x
			}
		}
	}()

	go func() {
		for i := 0; i < 100; i++ {
			fmt.Printf("producing %d:\n", i)
			c <- i
		}
	}()
    
    go func() {
		t := time.Tick(1 * time.Second)

		for {
			select {
			case <-t:
				print("--\n")

			}
		}
	}()

	time.Sleep(1 * time.Second)

	wg.Wait()

}
```
