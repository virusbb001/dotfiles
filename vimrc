"共通の設定を使う
set nocompatible

scriptencoding utf-8

"表示関係
set number
set showmode
set listchars=tab:>-,eol:$,nbsp:-
set list
set cursorline
set showcmd
set wrap
set hlsearch
set showtabline=2
set laststatus=2
"左
set statusline=%f[B-No.%n]%r%y\|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m
set statusline+=%=
"右
set statusline+=%l,%c%V%5P
set ruler
syntax enable

"エンコード関連
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,default

"<Tab>関連
set tabstop=4
set softtabstop=0
set expandtab

"折りたたみ関連
set foldcolumn=4
set foldmethod=indent

"UNDO関連
set undolevels=1000
"無限UNDO
if has('persistent_undo')
 set undodir=~/.vim/undo
 set undofile
endif

"検索
set noignorecase
set incsearch
set wrapscan

"バックアップ
set nobackup
set writebackup
"set backupext=.bak

"キー関連
set notimeout
set ttimeout
set timeoutlen=100
map Q gQ
"左右のみ
"上下はノーマルモードにもどれ
imap <C-f> <Right>
imap <C-b> <Left>
"insertモードに<C-p><C-n>は補完につかう

"どうしても我慢できなければq:を
cmap <C-p> <Up>
cmap <C-n> <Down>
cmap <C-f> <Right>
cmap <C-b> <Left>

"インデント
set autoindent
"set smartindent
set shiftwidth=1

"その他
set modeline
set noinsertmode
set backspace=2
set whichwrap=b,s,h,l,<,>,[,]
set autoread
set wildmenu
set history=100
filetype plugin indent on
if &encoding == 'utf-8'
 set ambiwidth=double
endif
"マウスを無効に
set mouse=
set nohidden
"set smarttab
"set showmatch
"colorscheme elflord
"autocmd FileType make setlocal noexpandtab

"自動コマンド
augroup VirusDropboxAuto
 autocmd!
 autocmd FileType perl,cgi compiler perl
augroup END
