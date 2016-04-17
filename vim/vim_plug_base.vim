" install command:
" curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh |
" sh -s ~/.vim/bundle
set nocompatible               " Be iMproved

set runtimepath^=/Users/virus/.vim/bundle/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('/Users/virus/.vim/bundle'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

call dein#add('vim-jp/vimdoc-ja')

" Add or remove your plugins here:
" call dein#add('Shougo/neosnippet.vim')
" call dein#add('Shougo/neosnippet-snippets')

" You can specify revision/branch/tag.
" call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
