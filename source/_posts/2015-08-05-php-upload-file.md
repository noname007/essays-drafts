---
title: PHP文件上传
layout: post
date: 2015-08-05 19:07:02
tags: 
- php
- nginx
- 配置
---

上传一个213M的文件的时候一直报IOerror。首先想到的是php上传文件大小的限制，改为300兆后，不起作用，就感觉是上传的的时候脚本执行的时间太长了，就修改`max_input_time` 为6000 还是不起作用，琢磨是不是`max_input_time`解析数据的时间出了问题，最后发现也不是，原来是nginx设置的太小了，改为500m,问题立马解决了。

php 和 nginx 设置如下


ngxin server 里面配置如下
```lisp
   server{
        ***
        client_max_body_size 1000M;
        ****
   }
```

php.ini 配置如下
```lisp
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
