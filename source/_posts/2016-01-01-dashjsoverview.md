---
title: dash 笔记
layout: post
tags:
  - 笔记
  - 工具
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2016-03-11 14:20:55
---


## 简介

从使用的角度来看，https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP 对dash协议已经有非常详细的描述。这只做一点简要的笔记。DASH (Dynamic Adaptive Streaming over HTTP，又名MPEG-DASH)是一种[自适应码流技术](https://en.wikipedia.org/wiki/Adaptive_bitrate_streaming)，类似于 HLS,其特点总的说就是

- 码率自适应，可以实现最大可能的观看质量较高的视频
- 跨设备，协议。可以从一些协议转化成另外一些协议，在不同的设备上观看
- 可以利用已有的 HTTP Web Server 基础设施资源，

[nimble](https://wmspanel.com/nimble)和[bitcodin](https://developer.bitcodin.com/doc/getting-started)的下面两张图最能说明

 ![](/imgs/bitcodindash.jpg) 
 ![](/imgs/NimbleStreamerFeature.png)


相关类似技术

- Adobe Systems HTTP Dynamic Streaming
- Apple Inc. HTTP Live Streaming (HLS) 
- Microsoft Smooth Streaming

支持的编码格式

- h.264 
- h.265
- vp9

支持的容器格式

- [ISO base media file format](https://en.wikipedia.org/wiki/ISO_base_media_file_format) (e.g. MP4 file format) 
- [MPEG-2 Transport Stream](https://en.wikipedia.org/wiki/MPEG_transport_stream)

将dash标准商业化，实现的相关组织

- DASH Industry Forum (DASH-IF)
- Microsoft,
- Netflix
- Google
- Ericsson
- Samsung
- Adobe
- 其他


## 样例
开始准备使用nginx-rtmp +dash.js 来做实现，dash.js无法播放，使用 [arut 修改过的dashjs](https://github.com/arut/dash.js)仍旧无法播放，看来还是对dash的支持还是有点问题，使用[dashif](http://dashif.org/reference/players/javascript/v2.0.0/samples/dash-if-reference-player/index.html#)给出的视频样例来做一个[demo测试](/demo/dashjs.demo.html)，感觉还行，

```html
<script src="http://cdn.dashjs.org/latest/dash.all.min.js"></script>


<body onLoad="Dash.createAll()">
      <div>
         <video class="dashjs-player" autoplay preload="none" controls="true">
            <source src="http://dash.edgesuite.net/dash264/TestCases/1a/sony/SNE_DASH_SD_CASE1A_REVISED.mpd" type="application/dash+xml"/>
         </video>
      </div>
</body>
```

