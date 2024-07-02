---
title: Gitlab CI/CD 改造回顾总结 ♻️
layout: post
categories:
  - 研发效能
tags:
  - Docker
  - Golang
date: 2024-06-04 15:23:30
description: 💪 改造公司基础设施
---

## 背景

我是22年入职的公司。

在熟悉环境的过程中发现：公司对 Go 的支持人力投入有限，构建过程缺少规范、没有指导文档。比我入职早的一位同事，靠自己东找找西找找，缝合了一个 Gitlab 的 `yml` 文件。

我当时觉得这是一个很奇葩的事情，就拉上中间件团队、研效、基础设施团队的同事组了一个公司的 Go 技术交流群。沟通过程中发现，构建 Go 基础镜像的 `Dockerfile` 文件也丢失了，这下可好一件事变成了两件事。

针对 `Gitlab 的编排流程`和 `Go基础镜像的构建`，结合自己的项目实际情况进行了`造轮子`。去年9月，研效团队把 `Go 基础镜像的构建` 的也接过手去了，对这件事算是画上了一个相对完满的句号。下面对造轮子的过程进行一个简要的回顾总结。

## 研发流程

先简单的说下 CI 流程

![集成、发版流程](/assets/2024-06-04-xhs-ci-cd-flow.png "代码集成、构建、发版流程")

1. 开发人员提交代码到 Gitlab
2. Gitlab CI/CD 自动构建
3. 构建成功后，镜像推送到 Harbor
4. 研发人员去发版系统选择构建好的镜像进行发布到测试、正式环境

## 改造

![](/imgs/2024-06-04-gitlab-ci-workflow.drawio.png "Gitlab CI/CD 工作流程")

### 改造 Golang 基础镜像
#### 反解旧镜像`Dockerfile`

```shell
docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage ${PRIVATE_DOCKER_REPO}/base/xhs-golang:1.15 
```
从输出结果来看主要需要做了如下几件事情
1. 基础镜像使用 `debian:buster-20200803`
2. copy go 1.15 的包到镜像内
3. 更改 apt 镜像源
4. 修改时区、语言设置、环境变量
5. 安装一些依赖使用的软件包

#### 重新封装 Golang 基础镜像 Dockerfile

基于反解后的信息，和同事先前做的 CI 脚本重新封装了一个 Golang 的基础镜像。

```Dockerfile
FROM golang:1.18-bullseye

RUN  cat /etc/apt/sources.list && \
     sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
     sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
     cat /etc/apt/sources.list && \
     apt update &&  \
     apt install upx -y && \
     rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
         && echo 'Asia/Shanghai' > /etc/timezone  \
         && echo "alias ll='ls -l --color'" >> /root/.bashrc

ENV  GO111MODULE=on GOPROXY=https://goproxy.cn GOPRIVATE=code.devops.xiaohongshu.com

RUN git config --global url."git@code.devops.xiaohongshu.com:".insteadof "https://code.devops.xiaohongshu.com/" && \
    git config --global --add url."git@code.devops.xiaohongshu.com:".insteadof "http://code.devops.xiaohongshu.com/"

COPY id_rsa /root/.ssh/
COPY id_rsa.pub /root/.ssh/

RUN  ssh-keyscan code.devops.xiaohongshu.com > /root/.ssh/known_hosts && \
      chmod 600 ~/.ssh/id_rsa
```

1. 基于 Go 官方提供的最新镜像 `golang:1.18-bullseye`进行构建
2. 修改镜像源、安装需要的用到的软件包、清理 apt 包缓存、更改时区
3. 配置 Go 私有仓库、共有仓库代理。
4. 配置密钥，防止 gitlab 有些仓库因为权限问题无法拉取。密钥可以不配置，放在主机的某个文件路径下面，使用卷挂载的方式使进行共享。


### 改造 Golang 应用程序运行时镜像
#### 反解旧镜像`Dockerfile`

```shell
docker run -v /var/run/docker.sock:/var/run/docker.sock alpine/dfimage  ${PRIVATE_DOCKER_REPO}/base/xhs-debian:10
```

基础镜像的构建过程主要做了几件事：
1. 选定基础镜像： [debian:buster-20200803](https://dso.docker.com/images/debian/digests/sha256:a44ab0cca6cd9411032d180bc396f19bc98f71972d2398d50460145cab81c5ab)（xhs-debian构建时的 Debian latest 版本）
2. 本地化设置：更改时区、设置语言字符集、更改镜像源
3. 安装了一些非所有场景都需要的软件

#### 重新封装 Golang 应用程序运行时镜像 Dockerfile

原理弄清楚，问题就很容易解决。下面对应用程序的基础镜像每一步做如下的优化升级：

```Dockerfile
FROM debian:stable-slim

RUN  cat /etc/apt/sources.list && \
     sed -i "s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
     sed -i "s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list && \
     cat /etc/apt/sources.list

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
         && echo 'Asia/Shanghai' > /etc/timezone  \
         && echo "alias ll='ls -l --color'" >> /root/.bashrc
ENV LANG=C.UTF-8
```

1. 换一个比较精巧的OS ，最后选了 Debian Slim (↘️[alpine vs slim](https://groups.google.com/g/golang-nuts/c/15TLaxqUpA0))
   1. 镜像相对来说也比较小：删除了很多运行时用不到的东西
   2. glibc vs musl
      1.  ↘️[Functional differences from glibc](https://wiki.musl-libc.org/functional-differences-from-glibc.html)
      2. musl 跑纯 Go 的项目一般问题不大，但是碰到需要使用依赖 glibc 的项目就很麻烦
   3. 包管理器，线上出现问题时，还能使用包管理器安装 Deb 包 排查问题
   4. 运行时用不到的软件就不装了，除了浪费空间、增加攻击面暂时也没发现其他用处~
2. 镜像源、语言、时区，照抄原来镜像的设置

#### 效果
1. 镜像大小从 440M → 110M （alpine 能降到 36M ）
2. 285个中、高、致命漏洞 降低为 23 个低级风险问题

![](/imgs/2024-06-04-old-golang-runtime-docker-image.png "旧运行时镜像")


![](/imgs/2024-06-04-new-golang-runtime-container-image.png "新运行时镜像")


### 改造 `.gitlab-ci.yml` 

```bash
set -x
# 基于 Dockerfile 构建镜像，并将构建后的镜像推送到私有镜像仓库
function docker_build() {
    local app_id=$1
    local docker_tags=$2
    docker build .  -t ${PRIVATE_DOCKER_REPO}/qa/"$app_id":"$docker_tags"
    docker login -u username -p passwordk ${PRIVATE_DOCKER_REPO}
    docker push ${PRIVATE_DOCKER_REPO}/qa/"$app_id":"$docker_tags"
}



# 更改时区，不然 date 函数时间会计算错误
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
apk add -U tzdata
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
CURRENT_DATETIME="$(date +%Y%m%d_%H%M)"


tags=$1
bin=$2
cp "${bin}" ./app
docker_build ${APP_ID} "${tags}_${CURRENT_DATETIME}"
```

```yml
# 此镜像用于执行 docker 运行时镜像的构建
image: ${PRIVATE_DOCKER_REPO}/library/docker:v1.0

# gitlab 关键字，分几个阶段
stages:
  - compile
  - publish

# 代码编译阶段
compile:
  stage: compile
  image: ${PRIVATE_DOCKER_REPO}/qa/itworkspace:go_1.21_latest

  before_script:
    - go version
    - ls -alh
  script:
    - go mod tidy
    - go build -o ./app_dir/http ./cmd/http.go
    - upx ./app_dir/http
  
  # 编译成功后，将产物共享给下一个阶段
  artifacts:
    paths:
      - "./app_dir"
      - "./conf"
    untracked: false
    # 编译成功后，才进行产物缓存
    when: on_success

# 镜像构建阶段
publish_http:
  stage: publish
  script:
    - cp ./conf/app.sit.yaml ./conf/app.yaml
    - /bin/sh ./build.gitlab.sh sit_http ./app_dir/http
```

## 参考资料

1. {% douban book 26285268 %}


