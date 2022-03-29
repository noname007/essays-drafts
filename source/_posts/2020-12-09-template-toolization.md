---
layout: post
title: 利用工具生成 dcron 任务 
date: 2020-12-09 13:58:32 +0800
tags: 
- 工具
- rust
---

`模板问题工具化`


线上基于 Yii2 的 PHP 项目 需要跑很多后台进程，用来处理异步任务，如 IM通知、BPM、事件消费。

针对这些后台任务总结分析，发现如下四个特点：

- 定时执行
- 拉起异常推出的常驻进程
- 拉起时异常推出的日志记录到文件
- 路径固定：部署的代码、日志、缓存、配置等
- Yii2 Command 程序运行命令格式固定
- 结束常驻进程运行的程序 

基于此提炼出如下 cron 命令模板

{% raw %}
``` shell
ps aux|grep \"php /opt/www/htdocs/{}/yii {}\"|grep -v 'grep' || (php /opt/www/htdocs/{}/yii {} >> /opt/www/logs/{}/{} 2>&1 &

ps aux|grep \"php /opt/www/htdocs/{}/yii {}\"|grep -v 'grep'|awk '{{print $2}}' | xargs -n 1 kill -9
```
{% endraw %}

使用 rust 制造如下工具：

- module\_id: 项目名称比如 force-holo
- yii\_cmd: yii2 command 命令名字比如默认自带的 serve/index

因为文件名称中不能有 `/`，故进行替换 `cmd.replace("/", "-")`

{% raw %}

``` rust
use std::env::{args};

fn main() {
    if args().len() < 3 {
        println!("Usage： {} module_id yii2_cmd", args().nth(0).expect("executable program"));
        return;
    }
    let module_id = args().nth(1).expect("module_id");
    let cmd = args().nth(2).expect("command");

    // let kill = "ps aux|grep \"php /data0/www/htdocs/{}/yii {}\"|grep -v 'grep' || (php /data0/www/htdocs/{}/yii {} >> /data0/www/applogs/{}/{} 2>&1 &)";

    let run_cmd = format!("ps aux|grep \"php /data0/www/htdocs/{}/yii {}\"|grep -v 'grep' || (php /data0/www/htdocs/{}/yii {} >> /data0/www/applogs/{}/{} 2>&1 &)",
                           module_id, cmd, module_id, cmd, module_id, cmd.replace("/", "-"));

    println!("{}", run_cmd);

    let kill_cmd = format!("ps aux|grep \"php /data0/www/htdocs/{}/yii {}\"|grep -v 'grep'|awk '{{print $2}}' | xargs -n 1 kill -9",
                           module_id, cmd);
    println!("{}", kill_cmd);

}

```



``` shell
➜  gen-dcron git:(master) cargo build
➜  gen-dcron git:(master) target/debug/gen-dcron force-holo serve/index
ps aux|grep "php /data0/www/htdocs/force-holo/yii serve/index"|grep -v 'grep' || (php /data0/www/htdocs/force-holo/yii serve/index >> /data0/www/applogs/force-holo/serve-index 2>&1 &)
ps aux|grep "php /data0/www/htdocs/force-holo/yii serve/index"|grep -v 'grep'|awk '{print $2}' | xargs -n 1 kill -9

```
{% endraw %}


项目地址：[https://github.com/noname007/rust-demo-cron-cmd-for-yii2-proj](https://github.com/noname007/rust-demo-cron-cmd-for-yii2-proj)


-------------------------------------------------------------------------------

相关文章：
[琐事、工具](./2020-05-04-build-own-framework.md)

