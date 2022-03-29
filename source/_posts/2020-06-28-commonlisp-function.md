---
layout: post
title:  common lisp - 函数
date:   2020-06-28 13:56:36 +0800
tags: [common lisp,  函数]
---

* 目录
{:toc}

# 无参数

```lisp
(defun hello ()
	"print hello world"
	(format t "hello world~%"))
	(hello)
```

# 必要参数

```lisp
(defun fun-params-must (x y)
	"x + y"
	(format t "~a~%" (+ x y)))

(fun-params-must 1 2)
```


# 可选参数 ( 默认值参数 )

```lisp
(defun fun-params-opt-default (x y &optional w (z (progn (format t "opt z~%") x) z-su ))
	"function with opt   z-su ---> z-supplied-p"
	(list x y w z z-su))

(format t "~a ~%" (fun-params-opt-default 1 2 3))
(format t "~a ~%" (fun-params-opt-default 1 2 3 4))
```

# 剩余参数 ( 可变参数 )
```lisp
(defun fun-params-rest (x
	&optional y
		(z (progn (format t "z use default value ~%") (+ x y)) z-supplied-p)
	&rest values)
(format t "~a ~%" (list x y z z-supplied-p values)))
(fun-params-rest 1 2) ;;; (1 2 3 NIL NIL)
(fun-params-rest 1 2 3 4 5 6 7) ;;;; result: (1 2 3 T (A 4 B 5 C 6) 4 5 6)
```

# 关键字参数

``` lisp
(defun fun-params-key (x
	 &key  a (b (* 10 x) b-supplied-p)  ((:callers-name c) (* 20  x) c-supplied-p))
	(format t "~a ~%" (list x a b b-supplied-p c c-supplied-p)))

(fun-params-key 1) ;;; (1 NIL 10 NIL 20 NIL)
(fun-params-key 1 12 22 :b 5 :c 6  :a 4)  ;;; (1 4 5 T 20 NIL)  need restart-condition select
(fun-params-key 1 :b 5 :c 6  :a 4)  ;;; (1 4 5 T 20 NIL)
(fun-params-key 1 :b 5 :callers-name 6  :a 4)  ;;; (1 4 5 T 6 T)

```

- 关键字参数不要和可选参数、剩余参数混合使用，会出现一些奇怪的行为
- 关键字参数和可选参数同时存在时，用关键字参数替代


# 返回 return-from

```lisp
(defun fun-retun-from (n)
   (dotimes (i 10)
     (dotimes (j 10)
       (when (> (* i j) n)
         (return-from fun-retun-from (list i j))))))

(fun-retun-from 20)
```

# 函数作为数据

```lisp
 (defun fun-call-apply (a  b)
   (format t "~a~%" (list a b)))
(funcall #'fun-call-apply 20 1)
(apply #'fun-call-apply '(1 (2 3)))



(defun fun-call-apply (a  b &key k)
	(format t "~a~%" (list a b k)))

(funcall #'fun-call-apply 20 1)
(apply #'fun-call-apply '(1 (2 3) :k 1))
```

