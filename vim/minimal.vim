" vim -u /path/to/minimal_standalone.vim
if &compatible
 set nocompatible
endif

" auto install
let s:dein_dir=expand('~/tmp/cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
 let s:out = system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

" Add the dein installation directory into runtimepath
" set runtimepath+=~/tmp/cache/dein/repos/github.com/Shougo/dein.vim
let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

if dein#load_state(s:dein_dir)
 call dein#begin(s:dein_dir)

 call dein#add('Shougo/dein.vim')
 " plugin here
 call dein#end()
 call dein#save_state()
endif

filetype plugin indent on
syntax enable
