
set nocompatible

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set backspace=indent,eol,start

set t_Co=256
set title
set ruler
set nowrap
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp1251,koi8-r,cp866,default
set termencoding=utf-8

" backup not needed
set nobackup
set nowritebackup
" swapfiles are just moved to a separate direcory
set directory=/crypt/iv/.vimswap/

" these two line disable any bells:
set visualbell
set t_vb=

" don't mess with my clipboard unless I asked to
set clipboard-=autoselect

set wildmenu
set wildmode=longest,full
set completeopt=menu,longest
set laststatus=2 " always show statusline
set history=200

filetype plugin indent on
syntax on

set listchars=tab:»→,space:·,eol:$

colorscheme ron
colorscheme default
hi Operator ctermfg=11
hi Label ctermfg=11
hi Title ctermfg=213
hi htmlItalic cterm=bold

set tabstop=8
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4
set autoindent

set number
set incsearch
set hlsearch

set foldmethod=marker
set nofoldenable

" why there is /dev/null in grepprg?
set grepprg=grep\ -Hn

" Make deletion another change -- a life-saver sometimes.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" The same for every line
inoremap <CR> <CR><C-G>u

" Put path of current file into command line easily:
cabbr <expr> %/ expand('%:p:h')
cabbr <expr> %. expand('%:p:r')

" Use xdg-open in netrw
let g:netrw_browsex_viewer = 'xdg-open'

" {{{ Persistent undo -- sophisticated way

au BufReadPost * call ReadUndo()
au BufWritePost * call WriteUndo()
func MyUndoFile()
    return '/crypt/iv/.vimundo/' . substitute(expand('%:p'), '/', '__', 'g')
endfunc

func ReadUndo()
    if filereadable(MyUndoFile())
        exe 'silent rundo ' . escape(MyUndoFile(), " ")
    endif
endfunc
func WriteUndo()
    exe 'wundo ' . escape(MyUndoFile(), " ")
endfunc

" }}}

" {{{ Filetype-specific stuff:

" python
let python_highlight_all = 1
" autocmd filetype python set makeprg=pep8\ --repeat\ --ignore=W391,E201\ %
" uncomment if you don't have my awesome indent plugin:
" autocmd filetype python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" shell
let g:is_bash=1

" java
let java_allow_cpp_keywords = 1

" json
let g:vim_json_syntax_conceal = 0

" markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['bash=sh', 'java', 'python', 'html', 'javascript']
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2

autocmd filetype markdown hi link mkdCode PreProc
autocmd filetype markdown hi mkdCodeStart cterm=bold ctermfg=16 ctermbg=43
autocmd filetype markdown hi link mkdCodeEnd mkdCodeStart

" c family
set cinoptions=:0h4i0g0(0W2s

" go
" disable most of features, since most of my machines don't have Go installed
let g:go_highlight_functions = 0
let g:go_highlight_methods = 0
let g:go_highlight_fields = 0
let g:go_highlight_types = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_operators = 0
let g:go_highlight_build_constraints = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0
let g:go_get_update = 0
let g:go_def_mapping_enabled = 0
let g:go_echo_go_info = 0
let g:go_echo_command_info = 0


" vimplerator browser temporary files
autocmd BufNewFile,BufRead  vimperator*.tmp set linebreak nolist wrap

" spec files
function MyAddChangelog()
    write
    ! add_changelog "%"
    edit
    execute search('^%changelog') + 2
endfunction

" terraform
autocmd BufNewFile,BufRead  *.tf set syntax=conf
autocmd BufNewFile,BufRead  *.tfvars set syntax=conf

" consul-template
autocmd BufNewFile,BufRead  *.ctpl set syntax=goconftmpl

" others
autocmd filetype html set shiftwidth=2
autocmd filetype css set shiftwidth=2
autocmd filetype yaml set shiftwidth=2
autocmd filetype jade set shiftwidth=2
" autocmd filetype xml set shiftwidth=2
autocmd filetype scala set shiftwidth=2


" }}}

" {{{ Tslime

function! Send_to_Tmux(text)
  if !exists("g:tmux_target")
    call Tmux_Vars()
  end
  " can't use shellescape because of the way it escapes \n with \\
  " let text = "'" . substitute(a:text, "'", "\\\\'", 'g') . "'"
  let text = "'" . substitute(a:text, "'", "'\\\\''", 'g') . "'"
  call system("tmux send-keys -l -t " . g:tmux_target  . " " . text)
endfunction

function! Tmux_Pane_List(A,L,P)
  let format = "#D<#S:#I.#P #W #{pane_current_command}>"
  return system("tmux list-panes -a -F " . shellescape(format))
endfunction

function! Tmux_Vars()
  let pane = input("tmux target: ", "", "custom,Tmux_Pane_List")
  let g:tmux_target = substitute(pane, "<.*$" , '', 'g')
  echo "\ntmux target set to " . g:tmux_target
endfunction

vmap <C-c><C-c> "ry :call Send_to_Tmux(@r)<CR>
nmap <C-c><C-c> vip<C-c><C-c>

nmap <C-c>v :call Tmux_Vars()<CR>

" }}}

" {{{ Bad whitespace and spelling

" Highlight bad whitespace
highlight BadWhitespace ctermbg=black  guibg=black
autocmd BufNewFile,BufRead *{[^w]?,?[^s]} let b:mtrailingws=matchadd('BadWhitespace', '\s\+$', -1)

" When spell errors are not so eye-burning...
highlight SpellBad ctermbg=black
" ... it's possible to enable spell check by default
set spell
set spelllang=en,ru
" Disable check for sentence to start with capital letter
set spellcapcheck=

autocmd filetype gitcommit set spell spelllang=en
" }}}

" {{{ Rainbow Parentheses

let g:rbpt_colorpairs = [
    \ ['brown',       'White'],
    \ ['red',       'White'],
    \ ['yellow',       'White'],
    \ ['blue',       'White'],
    \ ['green',       'White'],
    \ ['cyan',       'White'],
    \ ['gray',       'White'],
    \ ['white',       'White'],
    \ ]

" au VimEnter * RainbowParenthesesToggle
" au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces

" }}}

" {{{ CtrlP

let g:ctrlp_map = '<Leader>e'
let g:ctrlp_use_caching=0
let g:ctrlp_regexp = 1
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:50'
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }


" }}}

" {{{ External commands

nmap <Leader>g :echo system("gh-link " . shellescape(expand("%")) . " " . line("."))<CR>
command -nargs=? -complete=dir Ctags ! ctags -R --c++-kinds=+p --fields=+iaS --extra=+q <args>
command -nargs=+ Ggrep cexpr system("git grep -nH " . shellescape(<q-args>))

" }}}

