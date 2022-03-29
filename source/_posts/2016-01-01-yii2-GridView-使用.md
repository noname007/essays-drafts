---
title: yii2 GridView 使用
layout: post
date: 2015-12-21 20:09:41
tags:
---
## GridView是什么？能做什么？
`GridView`是一个用于把数据显示在一个表格中的`yii2` `widget`

提供的功能，主要包括下面几种对数据的操作
- 使用表格显示数据
- 对表格中的列进行`排序`显示
- `分页`显示数据
- `过滤`显示那些数据


## GridView 怎么使用？

```php 
 <?= GridView::widget([
    'dataProvider' => $dataProvider,
    'columns' => [
        'id',
        'name',
        'created_at:datetime',
    ],
])?>
```

- columns 配置项中的缩写
- 组合模式+依赖注入



## GridView 源码分析


