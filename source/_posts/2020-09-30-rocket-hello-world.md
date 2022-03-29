---
layout: post
title:  Rust Rocket -- Hello World
date:   2020-09-30 16:00:59 +0800
tags: 
- rust
- rocket
---

* 目录
{:toc}

## 使用 CLion 新建项目

目录路径 `~/rocket_hello_world`

## 构建[^1]

Rocket 只能使用 nightly  版本 进行编译。

> Rocket makes abundant use of Rust's syntax extensions and other advanced, unstable features. Because of this, we'll need to use a nightly version of Rust

### 设置 Rust 编译器版本

全局设置

`rustup default nightly`


单个项目设置

`rustup override set nightly`

``` shell
$ cat ~/.rustup/settings.toml
default_host_triple = "x86_64-apple-darwin"
default_toolchain = "stable-x86_64-apple-darwin"
profile = "default"
version = "12"

[overrides]
"~/rocket_hello_world" = "nightly-x86_64-apple-darwin"

$ rustc -V
rustc 1.48.0-nightly (73dc675b9 2020-09-06)
```
 
### 添加依赖到 Cargo.toml

``` toml
[dependencies]
rocket = "0.4.5"
```

### 源码 

`main.rs`

``` rust 
#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

fn main() {
    rocket::ignite().mount("/", routes![index]).launch();
}

```

### 运行 ###

`cargo run`

[^1]: https://rocket.rs/v0.4/guide/getting-started/
