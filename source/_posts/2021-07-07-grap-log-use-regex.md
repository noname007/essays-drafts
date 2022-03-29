---
layout: post
title:  零宽断言
date:   2021-07-07 18:52:45 +0800
---

`\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d (.*\n)*?(?=\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)`

零宽度断言匹配的是一个位置

```shell

#irb

irb(main):018:0> /(?=\d)\d+(?=\d)/ === " 11 "
=> true

irb(main):020:0> /(?=\d)\d(?=\d)/ === " 11 "
=> true

irb(main):021:0> /(?=\d\d)\d(?=\d)/ === " 11 "
=> true




```
```
2021-07-07 17:16:13 [10.200.35.20][-][-][info][application] [app id:10012]
    in /data0/www/htdocs/holonet.intra.lianjia.com/common/SignKeyChainArrayProvider.php:41
    in /data0/www/htdocs/holonet.intra.lianjia.com/vendor/infrastructure/api-signature/src/Http/Yii2/SignFilter.php:60
2021-07-07 17:16:13 [10.200.35.20][-][-][info][yii\db\Connection::open] Opening DB connection: mysql:host=m7832.zeus.mysql.ljnode.com;port=7832;dbname=holonet
    in /data0/www/htdocs/holonet.intra.lianjia.com/module/identity/model/AppServiceQuery.php:45
    in /data0/www/htdocs/holonet.intra.lianjia.com/common/SignKeyChainArrayProvider.php:46
    in /data0/www/htdocs/holonet.intra.lianjia.com/vendor/infrastructure/api-signature/src/Http/Yii2/SignFilter.php:60
2021-07-07 17:16:13 [10.200.35.20][-][-][info][yii\db\Command::execute] SET SESSION wait_timeout = 28800
    in /data0/www/htdocs/holonet.intra.lianjia.com/config/db.php:17
    in /data0/www/htdocs/holonet.intra.lianjia.com/module/identity/model/AppServiceQuery.php:45
    in /data0/www/htdocs/holonet.intra.lianjia.com/common/SignKeyChainArrayProvider.php:46
2021-07-07 17:16:13 [10.200.35.20][-][-][info][yii\db\Command::query] SELECT `secret_key` FROM `app_service` WHERE (`app_id`='10012') AND (`service_id`=10010)
    in /data0/www/htdocs/holonet.intra.lianjia.com/module/identity/model/AppServiceQuery.php:45
    in /data0/www/htdocs/holonet.intra.lianjia.com/common/SignKeyChainArrayProvider.php:46
    in /data0/www/htdocs/holonet.intra.lianjia.com/vendor/infrastructure/api-signature/src/Http/Yii2/SignFilter.php:60
2021-07-07 17:16:13 [10.200.35.20][-][-][trace][yii\base\InlineAction::runWithParams] Running action: app\module\api\controllers\AppServiceController::actionAccessServiceList()
2021-07-07 17:16:13 [10.200.35.20][-][-][info][yii\db\Command::query] SELECT `as`.`app_id` AS `app_id`, `as`.`secret_key` FROM `app_service` `as` WHERE `service_id`='10002'
    in /data0/www/htdocs/holonet.intra.lianjia.com/module/identity/model/AppServiceQuery.php:36
    in /data0/www/htdocs/holonet.intra.lianjia.com/module/api/controllers/AppServiceController.php:28
2021-07-07 17:16:13 [10.200.35.20][-][-][info][application] [RESPONSE][GET api/app-service/access-service-list][[
    'code' => 0
    'msg' => '服务正常'
    'extra' => [
        1001007 => [
            'app_id' => '10007'
            'secret_key' => '7a8c8e384ffc7c0194'
        ]
        1001008 => [
            'app_id' => '10008'
            'secret_key' => 'c3264160624a9677c8'
        ]
        1001009 => [
            'app_id' => '10009'
            'secret_key' => '81a8bf7589a13f21f1'
        ]
        1001017 => [
            'app_id' => '10017'
            'secret_key' => '35741b5aa744c5518'
        ]
        1001023 => [
            'app_id' => '10023'
            'secret_key' => '5fee8f3d61f0cf5315a1d'
        ]
        1001025 => [
            'app_id' => '10025'
            'secret_key' => '838a843ecfc41084db'
        ]
        1001026 => [
            'app_id' => '10026'
            'secret_key' => '17b834119e6d8'
        ]
        1001002 => [
            'app_id' => '10002'
            'secret_key' => '8215d0a4fc997a8a'
        ]
        1001043 => [
            'app_id' => '10043'
            'secret_key' => 'b16f3c14cfe50cce'
        ]
        1001048 => [
            'app_id' => '1001048'
            'secret_key' => '26f035e8112d0cea5'
        ]
    ]
    'type' => 'app'
    'date' => '2021-07-07 17:16:13'
]]
    in /data0/www/htdocs/holonet.intra.lianjia.com/common/LogHttpReqRes.php:49
2021-07-07 17:16:13 [10.200.35.20][-][-][warning][yii\debug\Module::checkAccess] Access to debugger is denied due to IP address restriction. The requesting IP address is 10.200.35.20
```
