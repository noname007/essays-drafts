---
title: 使用命令行批量删除 Github 仓库
layout: post
categories:
  - 技术
tags:
- 软件工具
date: 2024-05-28 17:46:58
description: 使用命令行批量删除 Github 仓库
---

## 安装 gh

```bash
gh auth login
gh auth refresh -h github.com -s delete_repo
```

## 批量删除仓库

待删除的仓库批量放入 `github.repo.txt` 文本文件中，每行一个仓库名。

```bash
cat github.repo.txt | xargs -I {}  -n 1  gh repo delete {} --yes
```


![alt text](/assets/20240528.png "Image Title")
