---
title: Thrift  一种 协议-工具 设计方法
layout: post
tags:
  - 笔记
  - thrift
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2022-04-10 11:46:12
---

**双边通信是个复杂的问题**


### 请求 -  响应 ###

双边通信本质来说是`请求-响应`模型，主动方发出一个服务请求，被动方给一个服务结果应答。事很简单，但实现起来确很费劲。

传输层协议提供信道传输模型-如TCP，应用层协议提供信息标准格式封装模型-如HTTP,RPC。

Thrift的设计方式对应用层协议设计有很好的参考意义

## thrift  ##

```thrift
service HelloWorldService {
  string say(1: string username)
}
```

```java
public class SimpleServer {
    public static void main(String[] args) throws Exception {
        ServerSocket serverSocket = new ServerSocket(ServerConfig.SERVER_PORT);
        TServerSocket serverTransport = new TServerSocket(serverSocket);
        HelloWorldService.Processor processor =
                new HelloWorldService.Processor<HelloWorldService.Iface>(new HelloWorldServiceImpl());

        TBinaryProtocol.Factory protocolFactory = new TBinaryProtocol.Factory();
        TSimpleServer.Args tArgs = new TSimpleServer.Args(serverTransport);
        tArgs.processor(processor);
        tArgs.protocolFactory(protocolFactory);

        // 简单的单线程服务模型 一般用于测试
        TServer tServer = new TSimpleServer(tArgs);
        System.out.println("Running Simple Server");
        tServer.serve();
    }
}
```
结合代码，从架构上看拆分了四层[^1]

- 服务层 `HelloWorldServiceImpl`
- 处理层 `HelloWorldService.Processor`
- 协议层 `TBinaryProtocol.Factory`
- 传输层 `TServerSocket`

![](/imgs/thrift-arch-2022-04.png "https://www.cnblogs.com/mymelody/p/9474300.html")


## 分析 ##

### 为什么是 4 层 ###

正常来说一个系统会考虑这么几个最近本的问题：具体功能、吞吐量、作业时间,显然thrift考虑到了下面几个问题

1. 传输信道是什么？系统吞吐量如何？ 
 
2. 协议封装格式是什么？ 协议封装格式是否合法？

3. 一个系统不可能只有一个服务，不同服务请求的服务如何进行 路由分发 ？

4. 具体服务响应是什么，以何种封装格式返回？



### 设计者-使用者 ###

一个系统永远可以从设计者与使用者两个视角去看。thrift也不例外，暂时叫做 `协议框架设计者`与`协议使用者`，处理层是两者的边界，利用`钩子（注入）`进行关注点分离。

- 协议框架设计者
  
  关注的整体的效率吞吐量、idl compiler工具，
  
- 协议使用者
  
  关注的是工具易用性、接入成本。



### 标准 - 工具 ###

相比HTTP,thrift在模型上来说改进上进步不大，都在应用层。但通过对idl增加约束，引入工具，在工程上前进了一步，形成接口描述统一语言，减少沟通歧义。

### 设计工具留意的其他点 ###

- 学习成本

    带来额外的通信模型与工具学习成本
    
- 桥接
    
    以开头代码为例， idl生成的代码从一个项目角度来说是在接口层，接口层有一套自己的设计模型理念，服务层使用的工具有一套工具理念。这层代码的桥接，本质是两种理念的差异弥合
    
- 兼容性

  刨除标准版本升级导致的前向不兼容外，工具本身一定依赖其他工具，工具集合融入到另外的工具集合时就会遇到版本冲突问题。


## 参考资料 ##

[^1]: https://juejin.cn/post/6844903622380093447
[^2]: https://www.cnblogs.com/mymelody/p/9474300.html
[^3]: https://www.bilibili.com/video/BV1aL4y157s7
[^4]: https://www.bilibili.com/video/BV1j44y1q7fy
[^5]: https://thrift.apache.org/
