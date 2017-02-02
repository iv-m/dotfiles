if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'yaml'
endif

runtime! syntax/yaml.vim
unlet b:current_syntax
runtime! syntax/gotexttmpl.vim
unlet b:current_syntax

syn clear yamlFlowString
syn region yamlFlowString matchgroup=yamlFlowStringDelimiter start='"' skip='\\"' end='"'
            \ contains=yamlEscape,gotplAction
            \ nextgroup=yamlKeyValueDelimiter
syn region yamlFlowString matchgroup=yamlFlowStringDelimiter start="'" skip="''"  end="'"
            \ contains=yamlSingleEscape,gotplAction
            \ nextgroup=yamlKeyValueDelimiter

let b:current_syntax = "goyamltmpl"

" vim: sw=2 ts=2 et
