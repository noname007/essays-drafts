title: 视频直播、点播草稿
tags:
  - nginx-rtmp
date: 2015-09-06 00:00:00
---



##rtmp 指令---中继（relay）
    Syntax: pull url [key=value]*
    Context: application

创建pull中继，拉取远程的流放到本地使用，当有播放器连接的时候命令才会生效

Url 语法: `[rtmp://]host[:port][/app[/playpath]]`.

如果app没有指定，则使用本地请求中的app名字

|参数名称|说明|
|---|---|
|app|指明应用名称|
|name|绑定监听的本地流名字，为空则监听所有的流|
|tcUrl|自动构建如果为空|
|pageUrl||
|swfUrl||
|flashVer||
|playPath|远程播放地址|
|live|合并指定的行为，为直播流|
|start||
|stop||
|static|静态化，会在nginx 启动的时候创建|


**Example**

    pull rtmp://192.168.1.129/live/test name=ted;


##Notify相关指令
主要用于回调通知
###on_connect

    nginx 块: rtmp, server

当客户端发起一个连接的时候，同时将会发起一个异步的http请求，客户端连接将会被挂起等待http请求的结果。根据不同的结果做出不同的响应。

**返回结果**
- 2xx -- 刚才发起的RTMP会话请求继续
- 3xx -- 重定向到另外一个应用，应用名在`Location`响应头中
- 其他连接将会被丢弃

应用不能放在`application`块，连接阶段的时候还不知道具体是请求的哪一个应用。
HTTP请求默认使用POST方法。


###on_play
与on_connect 类似，只是返回结果为 `3xx`的时候需要指定新的流名称


##参考资料
- https://github.com/arut/nginx-rtmp-module/wiki/Directives#live
- http://blog.waterlin.org/articles/using-nginx-rtmp-module-to-build-broadcast-system.html?utm_source=tuicool