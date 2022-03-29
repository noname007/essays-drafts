---
layout: post
title:  docker-manjaro
date:   2020-12-08 12:32:57 +0800
tags:
- docker
---

### 基础 ###

https://www.zhihu.com/question/27561972


### 安装docker [^1][^2][^3] ####

``` shell
# Pacman 安装 Docker
sudo pacman -S docker

# 启动docker服务
sudo systemctl start docker 

# 查看docker服务的状态
sudo systemctl status docker
# 设置docker开机启动服务
sudo systemctl enable docker

```

``` shell
➜  ~ systemctl start docker 
➜  ~ systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
     Active: active (running) since Tue 2020-12-08 12:37:35 CST; 57s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 13531 (dockerd)
      Tasks: 14
     Memory: 38.5M
     CGroup: /system.slice/docker.service
             └─13531 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.305886008+08:00" level=warning msg="Your kernel does not >
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.305889412+08:00" level=warning msg="Your kernel does not >
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.306000578+08:00" level=info msg="Loading containers: star>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.416499556+08:00" level=info msg="Default bridge (docker0)>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.467739556+08:00" level=info msg="Loading containers: done>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.503929080+08:00" level=warning msg="Not using native diff>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.504139584+08:00" level=info msg="Docker daemon" commit=44>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.504228733+08:00" level=info msg="Daemon has completed ini>
12月 08 12:37:35 soul11201-latitude7300 dockerd[13531]: time="2020-12-08T12:37:35.535365612+08:00" level=info msg="API listen on /run/docke>
12月 08 12:37:35 soul11201-latitude7300 systemd[1]: Started Docker Application Container Engine.
➜  ~ syst                 
➜  ~ systemctl enable docker
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.

```
	
### 使用镜像加速[^1] ###


[^1]: https://blog.csdn.net/weixin_40422121/article/details/106032921

[^2]: https://zhuanlan.zhihu.com/p/125785517

[^3]: https://www.cnblogs.com/imzhizi/p/10718310.html

