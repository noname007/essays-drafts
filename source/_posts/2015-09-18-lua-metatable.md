---
title: 元表、元方法
layout: post
tags: 
- lua
- 元表
- 元方法
date: 2015-09-18 17:47:00


---

> 每一个类型都有一个元表。table和userdata可以有各自独立的元表，其他类型的值则共享其类型所属的单一元表

表是lua中非常重要的基本数据类型，实现其他的一些编程技术概念的基础，如模块、包、类。通过语言提供的元表和元方法可以更改表的表现行为。

###☆ 元方法

|元方法|简单描述|
|---|---|
|`__metatable` | 调用 setmetatable、getmetatable方法的时候会用到这个字段|
|`__index`  |当表中的索引不存在时，查找元表中是否设置了这个元方法|
|`__newindex`   |同上|
| `__add`   |+|
| `__sub`   |-|
| `__mul`   |*|
| `__div`   |/|
| `__unm`   |-(相反数)|
| `__mod`   |%|
| `__pow`   |^|
| `__concat` | `..` 连接操作符|
| `__eq` |等于|
| `__lt` |小于|
| `__gt` |大于|
| `__metatable` |保护作用|
| `__tostring`  |字符串化|
 
总的来说，在程序中通过`元方法`，可以：
- 更改`算符运算符`、`关系运算符`作用于表时的行为
- 更改对表中的元素的访问行为，简单说是重载了，`[]` ,`[]=` 运算符

这两个特性在C++特性中看起来是`运算符的重载`。与C++相比，Lua本身没有面向对象的支持，但是使用元方法，可以实现其中的继承，还可以实现其他的功能、如返回具有默认值的table、跟踪table访问、只读的table

###☆ 继承
从原型窗口继承所有不存在的字段
```lua
Window = {}   -- 名字空间

Window.prototype = {x = 0,y = 0,width = 300,height = 400}

Window.mt = {}

function Window.new(o)
    -- body
    setmetatable(o, Window.mt)
    return o
end


Window.mt.__index = function(tabel,key)
    print(key)
    return Window.prototype[key]
end

w = Window.new{10,20}
print(w.height)
``


```

###☆ 返回具有默认值的table
当访问Lua表中不存在的一个元素的时候默认的返回的是nil,如果不想返回nil,则可以利用使用`__index` 元方法更改返回值。可以使用下面几种方式

**方式一 :**  为每一个需要默认值的表创建一个新的元表

```lua
function set_default(t,default)
    --todo
    local mt = {
        __index = function()
            return default
        end
    }
    setmetatable(t, mt)
end

tab = {x = 1,y = 2}

print(tab.x,tab.y)
set_default(tab,0)
print(tab.x,tab.y,tab.z)

```

**方式二 :**  使用同一个元表，默认值在每个表的各自内部
当有很多表需要默认值的时候，方法一会创建大量的元表，降低效率，下面这种方法更合适。所有通过新元表解决方案都会有这个问题
```lua

local mt = {
    __index = function(t,key)
        return t.___
    end
}
function set_default(t,default)
    t.___ = default
    setmetatable(t, mt)
end

tab = {x = 1,y = 2}

print(tab.x,tab.y)
set_default(tab,0)
print(tab.x,tab.y,tab.z)


```

防止索引冲突，可以改进为如下

```lua
local key = {} ---- 防止索引冲突
local mt = {
    __index = function(t)
        return t[key]
    end
}
function set_default(t,default)
    t[key] = default
    setmetatable(t, mt)
end
```


###☆ 跟踪table访问


```
function proxy(t)
    --todo

    local  _t = t
    local _mt = {
        __index = function(t,k)
            print('access to element'..tostring(k))
            return _t[k]
        end,
        __newindex = function(t,k,v)
            print("update  element "..tostring(k).."to"..tostring(v))
            _t[k] = v
        end
    }

    setmetatable(t, _mt)
    t = {}
    return t
end

t = proxy{}
t.k = 111
print(t.k)
```


可以改进如下：
```lua
local index = {} -- 防止key 冲突
local _mt = {
    __index = function(t,k)
        print('access to element '..tostring(k))
        return t[index][k]
    end,
    __newindex = function(t,k,v)
        print("update  element "..tostring(k).." to "..tostring(v))
        t[index][k] = v
    end
}

function proxy(t)
    --todo
    local  proxy = {}
    proxy[index] = t
    setmetatable(proxy, _mt)
    -- t = proxy -- 方便 t = proxy(t),proxy(t)两种形式的调用 --- error  已经是局部变量t,和外围t不是一回事，受到名字的影响
    return proxy
end

```

###☆只读的table

```lua
function make_read_only_table(t) 
    local read_only = {} -- 重要的一步
    local mt = {
        __index = t,
        __newindex = function (t,k,v)
            error("attemp to update a read-only table")
        end
    }
    setmetatable(read_only, mt)
    return read_only
end

a = 'test'

t = make_read_only_table{13,4,6,name='webapp',temp=a}

a = 'dd'
print(t.temp)

t.temp = 1111



```


**方案二**

```lua


local index = {} -- 防止key 冲突
local _mt = {
    __index = function(t,k)
        print('access to element '..tostring(k))
        return t[index][k]
    end,
    __newindex = function(t,k,v)
        error("attemp to update a read-only table")
    end
}

function make_read_only_table(t) 
    local read_only = {}
    read_only[index] = t
    setmetatable(read_only, _mt)
    return read_only
end

a = 'test'

t = make_read_only_table{13,4,6,name='webapp',temp=a}

a = 'dd'
print(t.temp)

-- t.temp = 1111


```
