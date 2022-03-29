---
layout: post
title: 一条命令部署项目到开发机
date:   2020-07-08 11:18:04 +0800
---
* 目录
{:toc}


## 流程 ##

![](/assets/git-deploy.workflow.png)

- push 代码到 git  仓库
- 登陆远程机 (开发机、测试机)
- 进入项目目录，拉取最新代码 `git pull` 

## 公钥免密码登陆 ##

###  服务器开启免密码登陆配置 ###

[配置ssh使用密钥登录，禁止口令登录](./2016-08-08-ssh.md)

###  添加公钥到开发机 ###

```shell
ssh-copy-id -i root@dev-host-ip
```

## 一句话 shell 更新项目  ##

`ssh root@10.26.15.134 "shell command"`

#### 例： 更新一个 php composer 管理的项目 ####

假设项目在远程机的位置 /opt/src/project
 
```shell
ssh root@10.26.15.134 "cd /opt/src/project ;git reset --hard; git pull; /usr/local/php/bin/php  /usr/local/bin/composer install"
```
