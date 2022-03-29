---
layout: post
title:  Python 多线程处理任务
date:   2021-11-05 20:13:32 +0800
tags:
  - Python
  - thread
---

美餐每天发一个用Excel汇总的就餐数据，我们把它导入到数据库后，行政办公服务用它和公司内的就餐数据进行比对查重。

初始实现是单线程，和`import_records`去掉多线程后的部分差不多。

`读取Excel数据` ---> `发送到行政服务接口` 

安全起见线上操作放在了晚上进行。运行时发现每条数据导入消耗`1s`多，晚上十点开始跑这几千条数据想想都让人崩溃。

等着也是干等，下楼转两圈透透气，屋里龌龊的空气让人昏昏沉沉，寒冷让人清醒不少，突然想到为什么不用多线程呢？

第一版多线程和处理业务的程序糅合在了一起，跟屎一样难读。后面两天又抽了点时间重构了几个版本，分离出来一个线程池、迭代器和`import_records`。

清晰不少，但是迭代器被暴露了出来，需要`import_records`调用一下判断当前任务是否给当前线程处理，类似协程的思路。

暴露有好有坏，但已基本满足日常使用，可以往一边先放放了。读读书、看看电影，不亦乐乎 ：）。

```python
import threading

def task_pool(thread_num, task_fn):

  if thread_num <= 0 :
      raise ValueError

  threads = []

  def gen_thread_checker(thread_id, step):

      base = 1
      i = 0

      def thread_checker():
          nonlocal i

          i += 1
          # print((thread_id,i,step, i < base or (i - base) % step != thread_id))

          if i < base or (i - base) % step != thread_id:
              return False

          return True

      return thread_checker


  for x in range(0, thread_num):
    threads.append(threading.Thread(target=task_fn, args=(x,thread_num, gen_thread_checker(x, thread_num))))

  # 启动所有线程
  for t in threads:
    t.start()
  # 主线程中等待所有子线程退出
  for t in threads:
    t.join()
```


```python
import argparse
import re

import requests
from openpyxl import load_workbook
from requests import RequestException

import myThread

parser = argparse.ArgumentParser(description='美餐到店交易数据导入')
parser.add_argument('--filename', '-f', help='美餐到店交易数据 .xlsx 文件路径', required=True)
parser.add_argument('--thread_num', '-t', help='线程数量', default= 100, required=False)
parser.add_argument('--debug', '-d', help='调试模式', default= 0, required=False)
args = parser.parse_args()

filename = args.filename
thread_num = int(args.thread_num)
debug = args.debug

if debug:
    print((filename,thread_num,debug))


def add_meican_meal_record(data):
   pass

def import_records(thread_id, thread_number, thread_checker):
    wb = load_workbook(filename=filename)
    ws = wb.active

    for row in ws:
        #------------------------------------------
        if row[0].value is None:
            break

        if not thread_checker():
            continue
        #------------------------------------------

        if row[0].value == '日期' or row[0].value == '总计' or not re.findall('^\d{4}-\d{1,2}-\d{1,2}$', row[0].value):
            continue
        else:

            date = str.replace(row[0].value,'-', '')

            order_id = row[3].value
            restaurant_name = row[5].value
            meal_plan_name = row[6].value
            meal_staffid = row[10].value
            identify = row[11].value
    
            add_meican_meal_record({
                'orderId':order_id,
                'date': date,
                'meal_plan_name':meal_plan_name,
                'meal_staffid':meal_staffid,
                'identify':identify,
                'restaurant_name':restaurant_name
            })

myThread.task_pool(thread_num,import_records)
```
