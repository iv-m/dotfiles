if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'conf'
endif

runtime! syntax/gotexttmpl.vim
unlet b:current_syntax


syn keyword	confTodo	contained TODO FIXME XXX
" Avoid matching "text#text", used in /etc/disktab and /etc/gettytab
syn match	confComment	"^#.*" contains=confTodo,gotplAction
syn match	confComment	"\s#.*"ms=s+1 contains=confTodo,gotplAction
syn region	confString	start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
  \ contains=gotplAction
syn region	confString	start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline
  \ contains=gotplAction

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link confComment	Comment
hi def link confTodo	Todo
hi def link confString	String

let b:current_syntax = "goconftmpl"

" vim: sw=2 ts=2 et
