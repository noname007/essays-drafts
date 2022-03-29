---
layout: post
title: juqery权威指南学习笔记-1
date: 2014-01-11 09:50:49 +0800
---

基本上比着书上的程序照抄的一个程序.在runjs.cn上写的，感觉这个平台用来入门学习html,js,css感觉挺不错的，三种代码分别在不同的窗口写，显得比较清爽，其次还可以实时预览。因为

把addClass写成了addclass,结果一直出错，没注意大小写，血淋淋的教训啊。
```js
    $(
    	
    	function(){
    		$(".divTitle").click(
    			function(){	 $(this).addClass("divCurrent").next(".divContent").css("display","block");
    			}	
    		)
    }
    );
```
```css
    .divFrame{
    	width:260px;
    	border:solid 1px #666;
    	font-size:10pt;
    }
    .divTitle{
    	background-color:#eee;padding:5px;}
    .divContent{
    	padding:5px;display:none;}
    .divCurrent{background-color:red;}

```

```html
    <!DOCTYPE html>
    <html>
    	<head>
    		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    		<title>HelloWorld</title>
    	<script id="jquery_182" type="text/javascript" class="library" src="/js/sandbox/jquery/jquery-1.8.2.min.js"></script>
     
    	</head>
    	<body>
    		<div id = "divFrame">
    			<div  class = "divTitle">点我试一试</div>
    			<div class= "divContent">
    				HelloWorld!
    			</div>
    			
    		</div>
    			
    	</body>
    </html>
```
