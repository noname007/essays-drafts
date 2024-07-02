---
title: "迁回 Hexo"
layout: post
categories:
- [技术]
tags:
- hexo
- jekyll
- emacs
- waline
- org
description: 👌
date: 2022-03-26 19:18:34
---

## Hexo 2 Jekyll ##

Hexo 是最早使用的工具，样式精美，主题切换也是很方，便部署工具友好。年轻总爱折腾，16年切换到了 Jekyll。Jekeyll 主题很多，但切换麻烦。本地构建预览，每隔一段时间总是莫名的出一些问题，小问题不死人但很恶心人。

## Jekyll 2 Org ##

有段时间用 Emacs 很上头， 感觉 Markdown 好难用，折腾了一段时间 Org。DIY 友好，运维部署稍微有点麻烦。

## Hexo ##

对于工具简单前段时间就想着牵回来了，这么多年了，牵回来也每个头绪，心烦意乱，往后拖延~

最近看 Manjaro 电报群 的劝退文  https://blog.zhullyb.top/2021/01/01/Why-I-dont-recommend-Manjaro/ 发现这个Hexo主题不错，Fluid[^3] 文档也不错，瞬间感觉有点世外桃源人了，趁着有点心气，赶紧折腾下，切换回来。


老二最好的策略就是模仿，恩，开干，Hexo + Fluid + Waline 


Hexo 升级 [^2][^4]

```sh
// 配置镜像源
> npm config set registry https://registry.npmmirror.com

//以下指令均在Hexo目录下操作，先定位到Hexo目录
//查看当前版本，判断是否需要升级
> hexo version

//全局升级hexo-cli
> npm i hexo-cli -g

//再次查看版本，看hexo-cli是否升级成功
> hexo version

//安装npm-check，若已安装可以跳过
> npm install -g npm-check

//检查系统插件是否需要升级
> npm-check

//安装npm-upgrade，若已安装可以跳过
> npm install -g npm-upgrade

//更新package.json
> npm-upgrade

//更新全局插件
> npm update -g

//更新系统插件
> npm update --save

//再次查看版本，判断是否升级成功
> hexo version

// 安装 hexo 依赖
> npm i -d

// 更新 hexo 依赖
> npm update -d
```

Hexo + Fluid + Waline + Emacs + Markdown 就是以后的写字基本工具了。

[^1]: http://mpwang.github.io/2019/02/13/how-to-write-hexo-blog-with-org-mode/

[^2]: https://coldnew.github.io/hexo-org-example/2017/03/05/getting-started-with-hexo-and-org-mode/

[^3]: https://hexo.fluid-dev.com/docs/guide/#slogan-%E6%89%93%E5%AD%97%E6%9C%BA

[^4]: https://leimingshan.com/posts/d9017f30/
