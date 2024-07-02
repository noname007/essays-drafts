---
layout: post
title:  "jekyll 搭建小记"
date:   2016-11-11 19:59:19 +0800
categories:
- 技术
tags:
- jekyll
- ruby
published: true
---

* 目录
{:toc}

<!-- 命令行下安装 -->

## 安装依赖环境
- ruby
- gem
- nodejs
- python
- pygements

### ubuntu 使用rvm 来安装


```sh

curl -sSL https://rvm.io/mpapis.asc | gpg --import -

curl -sSL https://get.rvm.io | bash -s stable

sudo apt-get install nodejs

```

### windows 下安装

[下载](http://rubyinstaller.org/downloads/) `Ruby`、`DevKit`，并分别安装

#### 安装gem

进入DevKit目录，运行命令

```sh
ruby dk.rb init
ruby dk.rb install

```

## 安装jekyll

- 换成国内的gem源

```shell
gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/ -V
gem install liquid kramdown jekyll pygments.rb bundler
 bundler install
```
## 参考

- http://ruby-china.org/wiki/rvm-guide

- http://blog.csdn.net/fnzsjt/article/details/41729463

- http://www.jianshu.com/p/609e1197754c

- https://segmentfault.com/q/1010000000261050
