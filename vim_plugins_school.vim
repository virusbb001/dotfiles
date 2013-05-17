" 学校用

filetype off
filetype plugin indent off

let g:neobundle_default_git_protocol="https"

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc',{
   \'build':{
   \ 'windows' : 'make -f make_mingw32.mak',
   \ 'cygwin' : 'make -f make_cygwin.mak',
   \ 'mac' : 'make -f make_mac.mak',
   \ 'unix' : 'make -f make_unix.mak'
   \}
   \}

NeoBundle 'vim-jp/vimdoc-ja'

filetype on
filetype plugin indent on
