scriptencoding utf-8

if v:version < 704
 echohl WarningMsg
 echo "Vim's version is under 7.4"
 echo "plz upgrade vim"
 echohl None
 finish
end

if &compatible
 set nocompatible
endif

set runtimepath^=~/.vim/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir=expand('~/.vim/dein')
let s:toml_files=split(glob("<sfile>:p:h/*.toml"),"\n")

filetype plugin indent off

if dein#load_state(s:dein_dir)
 " vim_tomls
 " Required:
 call dein#begin(s:dein_dir,[expand('<sfile>')]+s:toml_files + [expand('~/.vim/dein.toml'),expand('~/.vim/dein_lazy.toml')])

 call dein#load_toml(expand('~/dotfiles/vim/dein.toml'), {'lazy' : 0})
 call dein#load_toml(expand('~/dotfiles/vim/dein_lazy.toml'), {'lazy' : 1})

 if filereadable(expand('~/.vim/dein.toml'))
  call dein#load_toml(expand('~/.vim/dein.toml'), {'lazy' : 0})
 endif
 if filereadable(expand('~/.vim/dein_lazy.toml'))
  call dein#load_toml(expand('~/.vim/dein_lazy.toml'), {'lazy' : 1})
 endif

 " Required:
 call dein#end()
 call dein#save_state()
end

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
