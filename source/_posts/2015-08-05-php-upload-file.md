---
title: PHP文件上传
layout: post
date: 2015-08-05 19:07:02
categories:
- [技术,PHP]
tags:
- PHP
- Nginx
---

{% note success %}
   工程问题的排查过程，就是渐进明细，分而治之的过程。不断缩小问题范围，直到解决问题。
{% endnote %}

上传文件一直报 `IOerror`错误，大小`213M`。 

PHP 上传文件大小的限制，改为300兆后，不起作用。上传时，脚本执行的时间很长，调大 PHP  `max_input_time`  配置项为6000 后, w问题还是不解决。修改 Nginx `client_max_body_size` 为`500M`, 问题立马解决了。

php 和 nginx 设置如下


ngxin server 里面配置如下
```nginx
   server{
      client_max_body_size 1000M;
   }
```

php.ini 配置如下
```ini
file_uploads = On ;是否允许通过HTTP上传文件的开关。默认为ON即是开
upload_max_filesize = 500M ;上传文件上限 
upload_tmp_dir ;文件上传至服务器上存储临时文件的地方，如果没指定就会用系统默认的临时文件夹。
如果要上传比较大的文件，仅仅以上两条还不够，必须把服务器缓存上限调大，把脚本最大执行时间变长 
post_max_size = 500M ; POST给PHP的所能接收的最大值
max_execution_time = 30 ; 每个PHP页面运行的最大时间值 Maximum execution time of each script, in seconds脚本最大执行时间 
max_input_time = 60 ; 每个PHP页面接收数据所需的最大时间 解析一次请求时间上线 Maximum amount of time each script may spend parsing request data 
memory_limit = 128M ;  每个PHP页面所吃掉的最大内存 内存上限 Maximum amount of memory a script may consume (128MB)
```

相关参数解释

##参考

http://www.jb51.net/article/18975.htm
http://www.360doc.com/content/13/1210/11/14452132_336027836.shtml
