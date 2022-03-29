---
layout: post
title:  构建 rust docker 镜像
date:   2020-12-21 16:35:09 +0800
tags:
- rust
- docker
---

https://doc.rust-lang.org/cargo/reference/config.html 

DockerFile

``` dockerfile
FROM rust:1.48.0

WORKDIR /usr/src/myapp
COPY . .

RUN pwd && cp /usr/src/myapp/cargo_config /usr/local/cargo/config &&ls -alh /usr/local/cargo/config &&  cargo build && cargo install --path .

CMD ["isc-event-display"]
```


`filename: cargo_config`

```toml 
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"

#http.check-revoke = false
# 替换成你偏好的镜像源
replace-with = 'tuna'

# 清华大学
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# 中国科学技术大学
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

# 上海交通大学
[source.sjtu]
registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"

# rustcc社区
[source.rustcc]
registry = "git://crates.rustcc.cn/crates.io-index"

```
