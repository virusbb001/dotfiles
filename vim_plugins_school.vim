" 学校用

let g:neobundle#types#git#default_protocol="https"

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc',{
   \ 'build':{
   \ 'windows' : 'make -f make_mingw32.mak',
   \ 'cygwin' : 'make -f make_cygwin.mak',
   \ 'mac' : 'make -f make_mac.mak',
   \ 'unix' : 'make -f make_unix.mak'
   \ }
   \}

NeoBundle 'Shougo/vimfiler'

NeoBundle 'vim-jp/vimdoc-ja'

NeoBundle 'kana/vim-textobj-user'
NeoBundle 'h1mesuke/textobj-wiw',{
   \ 'depends' : 'kana/vim-textobj-user' ,
   \ }

"VimFiler
nmap <F3> :VimFiler -toggle -buffer-name=virusVimFiler -split<CR>

filetype on
filetype plugin indent on
