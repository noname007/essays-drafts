---
layout: post
title:  docker-mysql
date:   2020-12-25 16:38:47 +0800
---




``` dockerfile
version: "3.1"
services: 
  db:
    container_name: my_db_dockername
    image: mysql:5.7
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    restart: always
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - ./mysql_data_holonet:/var/lib/mysql
```

MySql 的 docker 镜像起来后，宿主机默认是无法访问的，需要添加授权。


``` shell
docker-compose  up --remove-orphans -d
docker exec -it  my_db_dockername   /bin/sh
mysql -uroot -h127.0.0.1 -p
```


``` sql
grant all privileges on *.* to 'dbname'@'%' identified by 'dbpass' with grant option;
flush privileges;
```
