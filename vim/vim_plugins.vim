" install command:
" curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh |
" sh -s ~/.vim/bundle

scriptencoding utf-8

if v:version < 704
 echohl WarningMsg
 echo "Vim's version is under 7.4"
 echo "plz upgrade vim m8"
 echohl None
 finish
end

if &compatible
 " 既にオプションを設定した後にset nocompatibleすると値が変わる
 set nocompatible
endif

set runtimepath^=~/.vim/bundle/repos/github.com/Shougo/dein.vim

let s:dein_dir=expand('~/.vim/bundle')

if dein#load_state(s:dein_dir)
 " Required:
 call dein#begin(s:dein_dir)

 call dein#load_toml(expand('~/dotfiles/vim/dein.toml'), {'lazy' : 0})
 call dein#load_toml(expand('~/dotfiles/vim/dein_lazy.toml'), {'lazy' : 1})

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
