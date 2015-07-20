title: linux-cmd
tags:
---

#sort

|参数 |含义   |
|-----|-------|
|`-kx`  |按照第x列的大小进行排序|
|`-n `  |按照数字比较，默认字典序排序|


#du 
- `du -sh *` 
 统计当前文件夹下各个文件的大小
- `du -shm *` 
 统计当前文件夹下各个文件的大小,以`M` 为单位。`-shk` 以 `KB`为单位

#locate
{% blockquote %}
linux 下可以使用 locate 和 find 来查找文件,但是 locate 在定位时要比 find 快.

locate 并不是穿梭于档案文件中查找,而是在**数据库**查找文件.find 正好相反,他的查找要穿梭于档案文件中.


{% endblockquote %}
`locate [-ir] keyword` 
`locate -- u` 
####命令选项
|参数 |含义   |
|---- |---    |
|  u  |更新数据库|
|  i  |不区分大小写 |
|  r  |后面可以接收正则表达式|

**参考**
- [locate 在linux下快速定位文档](http://yijiebuyi.com/blog/58d0b9eec7f18769439f388a8037c151.html)

##问题总结 FAQ

1. crontab不执行问题
{% blockquote %}
    今天有个服务不能使用了，查来查去，原来 `crontab` 被干掉了。装上后还是无法运行，原来还要依赖 `crond` 这个服务
{% endblockquote %}

 -  检查文件具有可执行权限 `chmod a+x`
 -  crond服务是否启动。查看及启动方式 `service crond start` `service crond status`


**参考**
- [crontab不执行问题](http://www.nginx.cn/2451.html)
- [crond](http://baike.baidu.com/link?url=4A3zDEAEGxKEkZV0GihvwInk1Rx9lCsJEZTeBUCgZq6a_h519pBSgCaCynxbiURbpXFUZ7Qqn-iF2Pj6Wp58Bq)