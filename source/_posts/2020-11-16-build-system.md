---
layout: post
title:  软件构建系统
date:   2020-11-16 17:42:08 +0800
---


``` shell
#处理基础环境依赖
yum -y install php70w-ldap.x86_64

#处理配置
#composer install -vvv --no-dev
composer install -vvv
cp config/db.prod.php config/db.php
rm config/params.php
cp config/params.prod.php config/params.php

#sed -i '4,5s/^/#/g' web/index.php
#sed -i '10,12s/^/#/g' yii

#适配CI系统
mv web htdocs
mkdir build

rsync -av .  build/ --exclude=".git" --exclude=".gitlab"

tar -zcvf yii2.tar.gz build
mv yii2.tar.gz  build/


# IM 通知
function wechatwrok_bot() {
    echo "$1"  | xargs -I {} curl -s  -v 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=filled-with-your-wxwork-bot-key' -H 'Content-Type: application/json' -d '{ "msgtype": "text",  "text": {"content": "{}"}}'
}

wechatwrok_bot "${BRANCH_NAME} build finish,by ${CHANGE_AUTHOR}. Please go to ${BUILD_URL} and verify the build"

```

什么是构建系统

编译器、解释器，

Shell脚本、 Make 、CMake ， Jenkins、 Travis CI ，

各种语言的包管理系统比如 PHP/Composer Python/pip Ruby/gem  Node/npm Rust/Cargo，

对了还有 Git（最早的时候 PHP 项目我都是用 git 直接拉代码到线上运行时目录）

林林总总，很多工具都可以算得上是构建系统，但某些时候又算不上是。

为什么呢？不同场景使然。


从目的来说是，构建系统是一个辅助系统，辅助编写的软件变成一个稳定可运行的服务、功能

从流程来说是一个包含集成、编译、打包、发布、自动化测试等多个环节的系统。

从语言自身来说比如 C 语言的宏、libtool、PHP Composer Plugin 、Python Swig 等扩展语言边界，扩展构建工具能力的各种元编程系统、

可以用于辅助管理项目正常运转所需的依赖、配置等，说白了是一些代码生成辅助工具

凡此种种，可以看出构建系统是一种辅助处理软件边界、非核心功能的工具






