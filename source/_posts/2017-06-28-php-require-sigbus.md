---
layout: post
title:  "(= (PHP require) 引起的 SIGBUS)"
date:   2017-06-28 17:33:27 +0800
categories: notes
published: true
tags:
- php
- bug 分析
- 信号
- 技术
author: soul11201
---

* 目录
{:toc}

## sigbus coredump
php中有这么一个[问题][bug-52752], 到2017年仍然没有解决。大概是这么一个问题运行下面这句 shell 就可能出现下面的coredump。

`for ((n=0;n<100;n++)); do sapi/cli/php test.php & done`

test.php
```php
<?php
    $c = '<?php $string = "'. str_repeat('A', mt_rand(1, 256 * 1024)) ."; ?>.\r\n"
    file_put_contents(__DIR__ . '/test.tpl', $c);
    require_once __DIR__ . '/test.tpl';
```


```shell
(gdb) bt
#0  0x082fd8d6 in lex_scan (zendlval=0xbff7295c) at Zend/zend_language_scanner.c:930
#1  0x08324d5d in zendlex (zendlval=0xbff72958) at /root/php-5.3.3/Zend/zend_compile.c:4947
#2  0x082f7447 in zendparse () at /root/php-5.3.3/Zend/zend_language_parser.c:3280
#3  0x082fcc97 in compile_file (file_handle=0xbff72ad0, type=2) at Zend/zend_language_scanner.l:354
#4  0x082fcdec in compile_filename (type=2, filename=0xa179af0) at Zend/zend_language_scanner.l:397
#5  0x0837983e in ZEND_INCLUDE_OR_EVAL_SPEC_TMP_HANDLER (execute_data=0xa179a04) at /root/php-5.3.3/Zend/zend_vm_execute.h:5199
#6  0x08369b48 in execute (op_array=0xa1467a4) at /root/php-5.3.3/Zend/zend_vm_execute.h:107
#7  0x083398ca in zend_execute_scripts (type=8, retval=0x0, file_count=3) at /root/php-5.3.3/Zend/zend.c:1266
#8  0x082cc48f in php_execute_script (primary_file=0xbff77034) at /root/php-5.3.3/main/main.c:2275
#9  0x0840f171 in main (argc=3, argv=0xbff77174) at /root/php-5.3.3/sapi/fpm/fpm/fpm_main.c:1865
```


问题的原因 nikic 给出了很清晰的解释：
```
The issue here seems pretty clear. We are mmap()ing the file. While the file is mapped, it is modified, resulting in an effective ftruncate(). Here is what the man page for ftruncate() has to say on the topic:

If the effect of ftruncate() is to decrease the size of a shared memory object or memory mapped file and whole pages beyond the new end were previously mapped, then the whole pages beyond the new end shall be discarded.
 
If the Memory Protection option is supported, references to discarded pages shall result in the generation of a SIGBUS signal; otherwise, the result of such references is undefined.

This is precisely what we are observing here.
```

说白了就是`require_once`的`test.tpl`这个文件的大小在不停的变化， 从而导致这个问题。具体想深入了解下怎么回事的参考下 [tlpi Chapter 49][tlpi]。

怎么知道系统底层用 mmap引起的？可以用strace 跟踪上面 php 的运行，观察到 `require/require_once/include/include_once` 底层的系统调用。另外nikic上面也有提示。

## sigbus 最小完整问题复现
下面是一段c 代码模拟出现sigbus的情况，其实也是上面这个问题触发`sigbus`时， 最小完整问题复现代码。
- 我的系统页面大小为 4k （具体数值 linux 下可用 `getconf PAGESIEZE` 获得）

```c

#include<stdio.h>

#include <sys/mman.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <unistd.h>

int
main(int argc, char* argv[])
{
  int fd = open("test.tpl", O_WRONLY);
  struct stat s;
  fstat(fd, &s);
  char * file = mmap(NULL, 8192 , PROT_READ, MAP_PRIVATE, fd, 0);

  printf("%c",*(file + 4096)); //coredump sigbus

// 打印文件 test.tpl 内容
//  for(int i = 0; i<= s.st_size; ++i, a++)
//  {
//    printf("%c",*a);
//  }
////  sleep(5);
}

```



## 总结

如何避免这个 sigbus 引起的 coredump

- 不使用 `require/inlude` 函数加载大小变化文件。
- 如果非要加载的话，避免文件大小变化的同时加载文件。
- 如果文件大小变化的同时加载文件，保证`页面大小`不属于`文件大小变化的范围 (min,max) % 页面大小`。

上面三个建议都可以。

[bug-52752]: https://bugs.php.net/bug.php?id=52752
[tlpi]: https://github.com/noname007/some-software-bak/blob/master/The%20Linux%20Programming%20Interface.pdf
