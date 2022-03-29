---
layout: post
title:  使用 emacs projectile magit 管理项目代码
date:   2020-12-16 16:29:37 +0800
tags:
- emacs
- projectile
- magit
---

如丝般顺滑

```elisp
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/project-dir-path" "~/project-dir-parent-path))
```

https://github.com/bbatsov/projectile

https://vincent.demeester.fr/articles/emacs_projects.html

https://endlessparentheses.com/improving-projectile-with-extra-commands.html

https://www.reddit.com/r/spacemacs/comments/aibvd5/open_a_magit_buffer_for_a_projectile_project/
