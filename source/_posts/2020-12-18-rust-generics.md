---
layout: post
title:  rust 泛型
date:   2020-12-18 20:05:26 +0800
tags:
- rust
---

所有权

类型
属性
泛型

函数
特性

生命周期


重复


泛型定义函数、结构体、枚举和方法

```rust
fn largest<T>(list: &[T]) -> T {
}
```

std::cmp::PartialOrd  >



泛型实现特定的 trait

``` rust
impl Point<f32> {


impl<T> Point<T> {

impl<T, U> Point<T, U> {
    fn mixup<V, W>(self, other: Point<V, W>) -> Point<T, W> {
	
	
```


单态化

trait 以一种抽象的方式定义共享的行为

trait bounds 指定泛型是任何拥有特定行为的类型


一个类型的行为由其可供调用的方法构成。如果可以对不同类型调用相同的方法的话，这些类型就可以共享相同的行为了

实现 trait 时需要注意的一个限制是，只有当 trait 或者要实现 trait 的类型位于 crate 的本地作用域时，才能为该类型实现 trait。

相干性（coherence） 

孤儿规则（orphan rule）
