title: sumlime 3 插件工具
tags: 
---


```python
import urllib.request,os,hashlib; h = 'eb2297e1a458f27d836c04bb0cbaf282' + 'd0e7a3098092775ccb37ca9d6b2e4b7d'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by) 
```

AutoFileName
CTags
SublimeCodeIntel

theme 
Vim BlackBoard
Markdown Preview
[markdown-slideshow]( https://github.com/ogom/sublimetext-markdown-slideshow/blob/gh-pages/docs/index.md)




"All Autocomplete",
"BracketHighlighter",
"C Improved",
"Color Highlighter",
"ConvertToUTF8",
"Cscope",
"CTags",
"DocBlockr",
"Function Name Display",
"Git",
"Markdown Preview",
"MarkdownEditing",
"Package Control",
"Pandown",
"PlainTasks",
"Preferences Editor",
"Racket",
"RailsCasts Colour Scheme",
"SFTP",
"Sublimall",
"SublimeCodeIntel",
"sublimelint",
"SublimeLinter",
"SublimeREPL",
"SyncedSideBar",
"Theme - Cobalt2",
"Theme - Vim Blackboard",
"Xdebug Client"

##lua 工具
"SublimeLinter-lua",
"Lua Love",


[关于PHP程序员解决问题的能力](http://rango.swoole.com/archives/340)

[线上php问题排查思路与实践](http://www.bo56.com/%E7%BA%BF%E4%B8%8Aphp%E9%97%AE%E9%A2%98%E6%8E%92%E6%9F%A5%E6%80%9D%E8%B7%AF%E4%B8%8E%E5%AE%9E%E8%B7%B5/)



