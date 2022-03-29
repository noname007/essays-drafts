---
layout: post
title:  Yii2 、socket 与 多进程
date:   2021-06-20 15:31:40 +0800
---

* 目录
{:toc}



前两周做 code review的时候发现同事用了许久不见的 pcntl 扩展，每个进程用来消费一个 redis channal 提高对消息处理的吞吐量。

因为PHP 自身的一些原因，这套扩展在 PHP 中是不怎么常用的。记得比较有名的一个项目是 workerman。

多进程这块技术其实是一个挺对自身知识量存储的灵魂拷问，往深处挖，可以挖出来无数的东西：事务、锁、信号、IPC、IO操作、socket、多线程，这些都与进程有千丝万缕的关系。

## 几行代码

下面这段代码中 redis socket 链接会不会在多进程间共享，redis 指令取出的数据结果会不会错乱分配到非对应的进程？


```php
<?php
	......
	$redis = \Yii::$app->redis;

        $pid = pcntl_fork();
        if ($pid == 0) {	
            $key = 'redis-key';
            while (true) {
                $data = $redis->lpop($key);

	......
```

## `man  2`   Linux Programmer's Manual



### man 2 fork

```shell
       *  The child inherits copies of the parent's set of open file descriptors.  Each file descriptor in the child refers to the same  open
          file  description (see open(2)) as the corresponding file descriptor in the parent.  This means that the two file descriptors share
          open file status flags, file offset, and signal-driven I/O attributes (see the description of F_SETOWN and F_SETSIG in fcntl(2)).
```


父子进程间会 COPY 文件描述符，


### man 2 soccket

```shell
 socket()  creates  an  endpoint for communication and returns a file descriptor that refers to that endpoint.  The file descriptor re‐turned by a successful call will be the lowest-numbered file descriptor not currently open for the process.
```

socket 套接字是文件描述符。


又去翻阅了一下 unix网络编程 apue资料查阅了一下。unpv1 对多进程 socket 通信模型讲的很是浅显易懂，这里不再赘述。

基本可以确定socket 套接字如果在fork之前创建。TCP 链接链接就会被多个进程复用。对端无法区分是那个父子进程谁发过来的数据。

但是还是需要写代码验证一下，理论总是要是经过实践的检验才会踏实。

## 实验


```c

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define MAXLINE  4096

int main(int argv, char * argc[])
{
    char	recvline[MAXLINE + 1];

    int s = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in server_addr;

    bzero(&server_addr, sizeof(server_addr));

    server_addr.sin_port = htons(8888);
    server_addr.sin_family = AF_INET;
    inet_pton(AF_INET,"127.0.0.1", &server_addr.sin_addr);

    if(connect(s, (const struct sockaddr *) &server_addr, sizeof(server_addr)) < 0)
    {
        printf("connect error");
    }

    int pid = fork();

    if(pid == -1) {

        printf("%d", getpid());
        char* msg = "error";
        write(s,msg, strlen(msg));

    }else if(pid == 0) {
        printf("this is parent proecess, pid: %d ppid: %d\n", getpid(), getppid());
        char* msg = "this is parent proecess,\n\n";
        write(s,msg, strlen(msg));
        int n = 0;
        while ( (n = read(s, recvline, MAXLINE)) > 0) {
            printf("\n Parent receive bytes:%d\n",n);

            recvline[n] = 0;	/* null terminate */
            if (fputs(recvline, stdout) == EOF) {
                printf("%s\n", strerror(errno));
            }
        }
    }else{
        char* msg = "this is child proecess,\n\n";
        write(s,msg, strlen(msg));
        printf("this is child proecess, pid: %d ppid: %d\n", getpid(), getppid());


        int n = 0;
        while ( (n = read(s, recvline, MAXLINE)) > 0) {
            printf("\n Child receive bytes:%d\n",n);
            recvline[n] = 0;	/* null terminate */
            if (fputs(recvline, stdout) == EOF) {
                printf("%s\n", strerror(errno));
            }
        }
    }

    return 0;
}

```

```shell
# gcc fork_t.c && ./a.out
this is child proecess, pid: 9898 ppid: 5322
this is parent proecess, pid: 9899 ppid: 9898

 Parent receive bytes:7
aaaaaa

 Child receive bytes:7
aaaaaa

 Child receive bytes:7
aaaaaa

 Child receive bytes:8
aaaaaaa

 Child receive bytes:7
aaaaaa

 Child receive bytes:7
aaaaaa

 Child receive bytes:7
aaaaaa

 Child receive bytes:7
aaaaaa


```

```shell
# nc -ltx -p8888 
this is child proecess,

Received 25 bytes from the socket
00000000  74 68 69 73  20 69 73 20  63 68 69 6C  64 20 70 72  this is child pr
00000010  6F 65 63 65  73 73 2C 0A  0A                        oecess,..       
this is parent proecess,

Received 26 bytes from the socket
00000000  74 68 69 73  20 69 73 20  70 61 72 65  6E 74 20 70  this is parent p
00000010  72 6F 65 63  65 73 73 2C  0A 0A                     roecess,..      
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaaa
Sent 8 bytes to the socket
00000000  61 61 61 61  61 61 61 0A                            aaaaaaa.        
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         
aaaaaa
Sent 7 bytes to the socket
00000000  61 61 61 61  61 61 0A                               aaaaaa.         

```



## 关键就看这了 `$redis = \Yii::$app->redis;`


Yii2 中的组件依靠  `yii\di\ServiceLocator` 进行管理，它是一个控制反转依赖注入的实现。下面是部分代码片段：获取对象实例与注入对象定义。


```php

<?php

 /**
     * Returns the component instance with the specified ID.
     *
     * @param string $id component ID (e.g. `db`).
     * @param bool $throwException whether to throw an exception if `$id` is not registered with the locator before.
     * @return object|null the component of the specified ID. If `$throwException` is false and `$id`
     * is not registered before, null will be returned.
     * @throws InvalidConfigException if `$id` refers to a nonexistent component ID
     * @see has()
     * @see set()
     */
    public function get($id, $throwException = true)
    {
        if (isset($this->_components[$id])) {
            return $this->_components[$id];
        }

        if (isset($this->_definitions[$id])) {
            $definition = $this->_definitions[$id];
            if (is_object($definition) && !$definition instanceof Closure) {
                return $this->_components[$id] = $definition;
            }

            return $this->_components[$id] = Yii::createObject($definition);
        } elseif ($throwException) {
            throw new InvalidConfigException("Unknown component ID: $id");
        }

        return null;
    }

    /**
     * Registers a component definition with this locator.
     *
     * For example,
     *
     * ```php
     * // a class name
     * $locator->set('cache', 'yii\caching\FileCache');
     *
     * // a configuration array
     * $locator->set('db', [
     *     'class' => 'yii\db\Connection',
     *     'dsn' => 'mysql:host=127.0.0.1;dbname=demo',
     *     'username' => 'root',
     *     'password' => '',
     *     'charset' => 'utf8',
     * ]);
     *
     * // an anonymous function
     * $locator->set('cache', function ($params) {
     *     return new \yii\caching\FileCache;
     * });
     *
     * // an instance
     * $locator->set('cache', new \yii\caching\FileCache);
     * ```
     *
     * If a component definition with the same ID already exists, it will be overwritten.
     *
     * @param string $id component ID (e.g. `db`).
     * @param mixed $definition the component definition to be registered with this locator.
     * It can be one of the following:
     *
     * - a class name
     * - a configuration array: the array contains name-value pairs that will be used to
     *   initialize the property values of the newly created object when [[get()]] is called.
     *   The `class` element is required and stands for the the class of the object to be created.
     * - a PHP callable: either an anonymous function or an array representing a class method (e.g. `['Foo', 'bar']`).
     *   The callable will be called by [[get()]] to return an object associated with the specified component ID.
     * - an object: When [[get()]] is called, this object will be returned.
     *
     * @throws InvalidConfigException if the definition is an invalid configuration array
     */
    public function set($id, $definition)
    {
        unset($this->_components[$id]);

        if ($definition === null) {
            unset($this->_definitions[$id]);
            return;
        }

        if (is_object($definition) || is_callable($definition, true)) {
            // an object, a class name, or a PHP callable
            $this->_definitions[$id] = $definition;
        } elseif (is_array($definition)) {
            // a configuration array
            if (isset($definition['__class'])) {
                $this->_definitions[$id] = $definition;
                $this->_definitions[$id]['class'] = $definition['__class'];
                unset($this->_definitions[$id]['__class']);
            } elseif (isset($definition['class'])) {
                $this->_definitions[$id] = $definition;
            } else {
                throw new InvalidConfigException("The configuration for the \"$id\" component must contain a \"class\" element.");
            }
        } else {
            throw new InvalidConfigException("Unexpected configuration type for the \"$id\" component: " . gettype($definition));
        }
    }
```




结合 `yii\redis\Connection` 中的代码可以看出， `$redis = \Yii::$app->redis;` 只生成了一个 `yii\redis\Connection`对象，但是对socket创建却是惰性计算的，没有立即创建 socket。


## 结论
开头的问题也就有了答案，不会。

