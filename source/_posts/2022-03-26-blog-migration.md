---
title: "博客迁移"
layout: post
tags:
  - 笔记
  - 穷折腾
description: 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处
date: 2022-03-26 19:18:34
---

## Hexo 2 Jekyll ##

Hexo 是最早使用的工具，样式确实很精美，使用也时相当人性化，主题切换也是很方便，抱着不折腾难受死的心态，16年的时候切换到了 Jekyll。Jekyll 我能得到什么好处呢，我不知道，但是不折腾我会很难受，总有一些妄念，折腾了就能写出好文章了。

## Jekyll 2 Org ##

使用 Jekyll 也总感觉这里不太对劲，哪里也不太对劲，隐约感觉也不是我要找的工具。有段时间 感觉 Markdown 好难用，用 Emacs Org 感觉很爽，折腾了一段时间 Org ，也发现有些不如人意的地方，主题真是太难看了，虽然说要要做一个重视内容的而不是形式的人，对我这种每天大量阅读电子屏幕的人，排版真的很影响阅读的心情，真是无法妥协。

## Hexo ##

总是想很多东西，但是一到写的时候不知何处下笔，思绪万千，抓耳挠腮。都说读书破万卷，下笔入有神，这是鬼扯，越写越有神才对。

也可能年纪大了，想法也变了，不想着折腾了，有个方便的工具用着能凑合凑合兑付着就挺好：方便速记，也能生成不错的排版方便沟通交流就挺好。

也不胡乱想了，贪多求全总不那么现实，用时间来慢慢的磨平不完美的地方，也只有时间能。

前段时间就想着牵回来了，这么多年了，牵回来也每个头绪，心烦意乱，往后拖延~

最近看 Manjaro 电报群 的劝退文  https://blog.zhullyb.top/2021/01/01/Why-I-dont-recommend-Manjaro/ 发现这个Hexo主题不错，Fluid[^3] 文档也不错，瞬间感觉有点世外桃源人了，趁着有点心气，赶紧折腾下，切换回来。


老二最好的策略就是模仿，恩，开干，Hexo + Fluid + Waline 


Hexo 升级 [^2][^4]

```sh
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

```

Hexo + Fluid + Waline + Emacs + Markdown 就是以后的写字基本工具了。

[^1]: http://mpwang.github.io/2019/02/13/how-to-write-hexo-blog-with-org-mode/

[^2]: https://coldnew.github.io/hexo-org-example/2017/03/05/getting-started-with-hexo-and-org-mode/

[^3]: https://hexo.fluid-dev.com/docs/guide/#slogan-%E6%89%93%E5%AD%97%E6%9C%BA

[^4]: https://leimingshan.com/posts/d9017f30/
