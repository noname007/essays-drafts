title: 视频直播、点播草稿
tags: 
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

##参考资料
- https://github.com/arut/nginx-rtmp-module/wiki/Directives#live
- http://blog.waterlin.org/articles/using-nginx-rtmp-module-to-build-broadcast-system.html?utm_source=tuicool