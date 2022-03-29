---
layout: post
title:  python 更新 git 项目
date:   2020-12-13 13:48:56 +0800
tags:
- 技术
- python
---

在目录 `/home/soul11201/code/emacs` 下面放了很多 `elpa` 没有管理的 gihub上的 emacs lisp 包，每次更新都需要手动更新挺费事。



``` python

import os

abs_dir = os.path.abspath("")
print({"当前目录":abs_dir, "git dir: ":os.listdir()})
# print()

# print({"a":"b"})

for dir in os.listdir() :
    git_dir = os.path.join(abs_dir, dir)
    # print((dir,os.path.isdir(dir)))
    print("\n",(git_dir, os.path.isdir(git_dir)))

    if os.path.isdir(git_dir) :
        print("change to dir:", git_dir)
        os.chdir(git_dir)
        os.system("git pull --rebase")
```
