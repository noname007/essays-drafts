title: 使用nginx实现视频点播
date: 2015-08-17 14:54:36
tags:
- nginx
- nginx-rtmp-module
- rtmp
---

[文档](https://github.com/arut/nginx-rtmp-module/wiki/Directives#video-on-demand)

使用 play 相关的指令可以实现点播功能。相关命令:
- play
- play_temp_path
- play_local_path


##配置

使用play命令可以点播mp4和flv文件。文件路径支持`本地目录`和http指定的`url`路径。

```conf
#本地文件
application vod {
    play /var/flvs;
}

#网络中的文件
application vod_http {
    play http://myserver.com/vod;
}
```

- play 指令中可以指定多个文件路径

- 多个play指令的时候，会合并指令中的位置。在播放的时候会在这些路径列表中的文件夹下依次查找，查不到，就会给前端返回一个错误。
 
- mp4 文件需要 采用 H.264 和 AAC 格式编码。

- flv文件点播需要添加关键帧（可以使用yamdi添加），`record` 指令生成的文件没有关键帧。


当播放一个网络文件时，nginx会先把文件下载完，然后才播放。下载文件临时存放的位置由`play_temp_path`指定，默认是存在`/tmp`文件夹下。另外，可以使用 `play_local_path`指令，把下载的文件复制到本地，配合play指令可以指定多个路径列表的特点，提高性能，不用是ngx每次都去下载网络视频资源。


配置更改如下即可实现点播url指定的文件，同时可以将文件缓存再本地，提高性能。
```conf
#网络中的文件
application vod_http {
    play_local_path /tmp/videos;
    play /tmp/videos http://example.com/videos;
}
```

##添加关键帧

    yamdi –i src.flv –o dst.flv

[yamdi 文档](http://yamdi.sourceforge.net/)

##点播视频

可以使用ffmpeg自带的ffplay

    ffplay rtmp://localhost/vod//dir/file.flv