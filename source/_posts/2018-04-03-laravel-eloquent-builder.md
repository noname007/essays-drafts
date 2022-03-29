---
layout: post
title:  "Laravel Eloquent Builder 的使用、源码简单分析总结"
date:   2018-04-03 20:10:37 +0800
categories: notes
tags:
- php
- Laravel
published: true
author: soul11201
---
* 目录
{:toc}


## 为什么要使用 Query Builder

Query builder的最大好处就是，对于SQL的 `select` `from` `where` `join` `group by` `order by` `limit` `offset` `having` `on`等关键字都转换为了类的方法，简化了SQL的使用成本，大大简化了代码量，原先一些操作数据库相关的一次性的servicelogic相关的函数，可以替换为直接 Builder 操作数据库。

Laravel中关键字都实现在了下面两个类中：

`\Illuminate\Database\Query\Builder`

`\Illuminate\Database\Query\JoinClause`

## 创建库 和 Model
接着上篇文章[对评论系统设计的一点总结](notes/2018/03/22/comment-summary.html)，总结一下Laravel Eloquent Builder的一些用法。

首先用下面的 MySQL 语句创建存储评论的数据库表，并生成Laravel对应的Model，用于检索数据库中的数据。

```sql
CREATE TABLE `Comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键,评论id',
  `replied_id` int(11) NOT NULL DEFAULT '0' COMMENT '被评论id',
  `replied_root_id` int(11) NOT NULL DEFAULT '0' COMMENT '直接评论id',
  `content` text COMMENT '评论内容',
  `status` int(11) DEFAULT NULL '评论状态',
  `from_user_id` int(11) NOT NULL DEFAULT '0' COMMENT '评论人id',
  `from_user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '评论人姓名',
  `to_user_id` int(11) DEFAULT '0' COMMENT '被评论人id',
  `to_user_name` varchar(20) NOT NULL DEFAULT '' COMMENT '被评论人姓名',
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

```php
<?php
/**
 * Created by PhpStorm.
 * User: yangzhen
 * Date: 2018/4/3
 * Time: 20:26
 */

namespace App\Model;


use Illuminate\Database\Eloquent\Model;

/**
 * App\Model\Comment
 *
 * @property int $id 主键,评论id
 * @property int $replied_id 被评论id
 * @property int $replied_root_id 直接评论id
 * @property string|null $content 评论内容
 * @property int|null $status
 * @property int $from_user_id 评论人id
 * @property string $from_user_name 评论人姓名
 * @property int|null $to_user_id 被评论人id
 * @property string $to_user_name 被评论人姓名
 * @property string $create_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereContent($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereCreateAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereFromUserId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereFromUserName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereRepliedId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereRepliedRootId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereStatus($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereToUserId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Model\Comment whereToUserName($value)
 */
class Comment extends Model
{
    protected $table = 'Comment';
    protected $primaryKey = 'id';
    public $timestamps = false;

}
```

## 使用案例

好，现在假想下面一个场景：

查询直接评论id分别为`10,11,12`的最近7天、评论内容含有关键字知识、发表评论用户名为`soull11201`或被评论用户名为`soul11201`、按照创建时间倒排后的前10条数据，并分别计算每个直接评论下面一共含有多少条数据。

粗暴的构造 sql 如下：。

```sql
-- 10
select  *  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 10 
    order by create_at desc
    limit 10;

select  count(1) replied_root_id10_total_num  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 10 

-- 11
select  *  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 11 
    order by create_at desc
    limit 10;

select  count(1) replied_root_id10_total_num  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 11 

-- 12
select  *  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 12
    order by create_at desc
    limit 10;

select  count(1) replied_root_id10_total_num  from Comment 
where 
    content  = '知识' 
    and (from_user_name = 'soul11201' or to_user_name = 'soul11201')
    and  replied_root_id = 12 
```


根据上面的 sql 构造，转换成如下的Eloquent Builder使用的代码:


```php
<?php
/**
 * Created by PhpStorm.
 * User: yangzhen
 * Date: 2018/4/3
 * Time: 20:46
 */


$replied_root_ids = [10, 11, 12];

//获取一个 \Illuminate\Database\Eloquent\Builder 实例
$query = \App\Model\Comment::query();

$query->where('content','知识')
    ->where(function (\Illuminate\Database\Eloquent\Builder $builder){
        //$builder 这是一个新的 builder 作为 $query  一个嵌入的查询 builder ,否则的话orWhere 根本无法实现（因为or的优先级问题），
        $builder->where('from_user_name', 'soul11201');
        $builder->orWhere('to_user_name', 'soul11201');
    });


$coments = [];
$total_num = [];

foreach ($replied_root_ids as $replied_root_id) {

    $new_query = \App\Model\Comment::whereRepliedRootId($replied_root_id)
        ->addNestedWhereQuery($query);
    
    //此处先用来查询总条数
    $total_num[$replied_root_id] = $new_query->count();
    //然后用来查询10条信息，顺序反之不可。
    $coments[$replied_root_id] = $new_query->orderBy('create_at', 'desc')
        ->limit(10)
        ->get()
        ->all();
}

```


## 执行流程分析


### `\Illuminate\Database\Eloquent\Builder::where()`

```php
    /**
     * Add a basic where clause to the query.
     *
     * @param  string|array|\Closure  $column
     * @param  string  $operator
     * @param  mixed  $value
     * @param  string  $boolean
     * @return $this
     */
    public function where($column, $operator = null, $value = null, $boolean = 'and')
    {
        if ($column instanceof Closure) {
            // 返回一个新的 Eloquent Builder
            $query = $this->model->newQueryWithoutScopes();
            //匿名函数调用，
            //当 where 条件有复杂的条件表达式的时候
            //比如解决上面 表达式中 (from_user_name = 'soul11201' or to_user_name = 'soul11201') or 优先级的问题
            //直接使用 where() 无法解决，只能使用一个新的Builder来嵌入到原先的Builder中
            $column($query);
            //$this->query 是类 \Illuminate\Database\Query\Builder 的实例
            //将新的 Eloquent builder 的 Query\Builder 最为一个整体嵌入到原先Eloquent Builder的 `Query\Builder`的where表达式中，
            //就可以解决上面 or 优先级的问题
            $this->query->addNestedWhereQuery($query->getQuery(), $boolean);
        } else {
            $this->query->where(...func_get_args());
        }

        return $this;
    }
```

### mixin
因为 `\Illuminate\Database\Eloquent\Builder` mixin 类`\Illuminate\Database\Query`

`\Illuminate\Database\Eloquent\Builder::count()`
`\Illuminate\Database\Eloquent\Builder::orderby()`
`\Illuminate\Database\Eloquent\Builder::limit()`

都是利用魔术方法`__call`间接使用的`\Illuminate\Database\Query`的方法

```php
    /**
     * The base query builder instance.
     *
     * @var \Illuminate\Database\Query\Builder
     */
    protected $query;
    
    ...
     此处省略
    ...
    
    public function __call($method, $parameters)
    {
        ...
        此处省略
        ...
        $this->query->{$method}(...$parameters);

        return $this;
    }

```
### `\Illuminate\Database\Eloquent\Builder::get()`


`\Illuminate\Database\Eloquent\Builder` 是 `\Illuminate\Database\Eloquent\Model`子类 与`\Illuminate\Database\Query\Builder` 沟通的桥梁。其中一个作用就是对`\Illuminate\Database\Query\Builder`查询的数组结果(由`\Illuminate\Support\Collection`进行包裹)渲染成`\Illuminate\Database\Eloquent\Model`子类的对象数组结果(由`\Illuminate\Database\Eloquent\Collection`进行包裹)。


```php
    /**
     * Execute the query as a "select" statement.
     *
     * @param  array  $columns
     * @return \Illuminate\Database\Eloquent\Collection|static[]
     */
    public function get($columns = ['*'])
    {
        //应用其他注入构造条件
        $builder = $this->applyScopes();

        // If we actually found models we will also eager load any relationships that
        // have been specified as needing to be eager loaded, which will solve the
        // n+1 query issue for the developers to avoid running a lot of queries.
        if (count($models = $builder->getModels($columns)) > 0) {
            $models = $builder->eagerLoadRelations($models);
        }

        return $builder->getModel()->newCollection($models);
    }

     /**
     * Get the hydrated models without eager loading.
     *
     * @param  array  $columns
     * @return \Illuminate\Database\Eloquent\Model[]
     */
    public function getModels($columns = ['*'])
    {
        return $this->model->hydrate(
            $this->query->get($columns)->all()
        )->all();
    }
```

### `Illuminate\Support\Collection::all()`

`\Illuminate\Database\Eloquent\Collection` 是`Illuminate\Support\Collection`的子类，`all()`方法指向的是同一个方法，直接返回其所包裹的数组。
