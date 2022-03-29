---
layout: post
title:  rust datetime
date:   2020-12-09 22:45:14 +0800
tags:
- rust
- datetime
---

https://docs.rs/chrono/0.4.19/chrono/

```rust

	let time = chrono::Utc::now();

    let f = FixedOffset::east(8*3600).from_utc_datetime(&time.naive_utc());
    
    let t =  f.format("%Y-%m-%d %H:%M:%S").to_string();
    

    let t1 = time.timestamp();
	
	
```


Django中与时区相关的安全问题 https://www.leavesongs.com/PYTHON/django-timezone-detail.html

https://www.codenong.com/cs106439523/

https://docs.djangoproject.com/zh-hans/3.1/topics/i18n/timezones/#

https://stackoverflow.com/questions/522251/whats-the-difference-between-iso-8601-and-rfc-3339-date-formats
