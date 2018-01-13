scriptencoding utf-8

if v:version < 704
 echohl WarningMsg
 echo "Vim's version is under 7.4"
 echo 'plz upgrade vim'
 echohl None
 finish
end

" auto install
let s:dein_dir=expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
 " ask install or finish
 echo 'dein not detected'
 let s:answer=confirm('Do you wanna install?', "&Yes\n&No")
 if s:answer == 2
  echo "OK, don't forget to comment out this script"
  finish
 endif
 call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

filetype plugin indent off

if dein#load_state(s:dein_dir)
 " vim_tomls
 " Required:
 call dein#begin(s:dein_dir,[$MYVIMRC, expand('<sfile>')])

 call dein#load_toml(expand('~/dotfiles/vim/dein.toml'), {'lazy' : 0})
 call dein#load_toml(expand('~/dotfiles/vim/dein_lazy.toml'), {'lazy' : 1})

 if filereadable(expand('~/.vim/dein.toml'))
  call dein#load_toml(expand('~/.vim/dein.toml'), {'lazy' : 0})
 endif
 if filereadable(expand('~/.vim/dein_lazy.toml'))
  call dein#load_toml(expand('~/.vim/dein_lazy.toml'), {'lazy' : 1})
 endif

if dein#tap('deoplete.nvim') && has('nvim')
  call dein#disable('neocomplete.vim')
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
