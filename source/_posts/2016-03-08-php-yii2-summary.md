---
title: 使用yii2框架开发的一点总结
layout: post
categories:
  - 技术
tags:
  - 开发
  - PHP
  - Yii2
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2016-03-08 15:44:50
---


噼里啪啦，最近使用yii2框架开发了几个项目（包括开源的[rss](https://github.com/noname007/learn-yii2)，[企业点餐系统](https://github.com/noname007/diandiandian))）。其中使用到了 GridView，gii，debug，migration，rbac，yii2-user，bootstrap 等模块。马上又要搞其他的东西去了，忘记东西的速度很快，所以下面总结一下整个过程中写代码的心得。


## 熟悉领域问题、概念
很多问题是问题领域不熟悉导致的，比如在写前端的时候bootstrap模块直接看代码注释文档，都不是特别理解在说什么，看源码，更是看不懂源码的思路逻辑，感觉肯定那里理解的出了问题，才导致自己使用工具才这么吃力，回头一想既然bootstrap插件是对bootstrap的一层封装，肯定是bootstrap里面的概念没理解清楚，然后就对着类名去搜bootstrap里面的一些概念，果然基本都有对应的，算是过去了这道坎。

## 分清角色、责任
不要重复造轮子，一个项目即使再怎么小，还是一个系统，会有大量的细节去要处理，如果自己真的要造轮子，真是难于上青天。就比如说我写的项目分这么几大块，基于角色的权限验证，前端，缓存，数据库，再加上业务上的逻辑处理，如果从头造轮子，简直累死，而且也说明自己分不清楚自己的在项目中的角色，在这个时期自己既是项目中的搬砖的程序员，还是整个系统的设计人员，还要和老大提出的需求来回进行确认系统到底要设计成什么样子的，这个时期更过的精力放在后两者角色中，而不是喜欢造轮子的程序员角色。解决问题的最好的方式是，选择模块化比较好的框架，并且还附带有大量的已经实现各种常见业务的第三方模块。框架本身基本上就能保证住项目的质量，模块化比较好，说明后期易于替换，优化。所以就决定使用yii2框架，其本身十分强大，语法也很是喜欢，加上及其附带的第三方模块，极大的提升了效率。<!-- 在编写界面代码的时候，php语言中的匿名函数提供了巨大的帮助。 -->


## 抽象是一把利剑
对付复杂化细节的有利方式就是使用抽象。比如这次使用了几家的服务做一间事情，每一家的服务不太一样，所以这时候对每一家提供的服务做一个对象抽象，这样就屏蔽了使用这个服务的程序对细节的依赖，而只是对这个抽象的依赖。具体抽象的方式就是使用了策略模式，这个模式想想真的很重要，比如ffmpeg里面针对解码就是用了策略模式的思想，还可以实现软件的热插拔，也可以提高程序的健壮性(例如这家的服务挂了，我就使用下一家的，如果全挂了，那就真没辙了，赶紧速错)，


## 这是一个流程问题
做一个系统和一个项目中一点最重要的区别感觉就是，把整个系统的流程完全跑通优先级提高一些，而不能想做一点的时候下很大的劲去做优化，调优。并且还要尽快实现，这样就尽可能的保证有一个比较小而简单的原型，小，设计出了问题，就可以方便修改。

## 扩展性
像yii2这种框架就比较好，提供了事件、行为、模块等方式可以很好的实现扩展。
