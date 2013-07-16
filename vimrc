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
let &termencoding = &encoding
set encoding=utf-8
"保存
if ( &modifiable )
 set fileencoding=utf-8
endif
"開く
set fileencodings=ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,default,latin

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
set hidden
set completeopt-=preview
"set smarttab
"set showmatch
"colorscheme elflord
"autocmd FileType make setlocal noexpandtab
"
if has('vim_starting')
 let &runtimepath.=',' . expand('$VIMRUNTIME')
endif

"自動コマンド
augroup VirusDropboxAuto
 autocmd!
 autocmd FileType perl,cgi compiler perl
 autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

"file name:.vimrc.local
"
function! s:vimrc_local(loc)
 let files = findfile('.vimrc.local',escape(a:loc,' ').';',-1)
 for i in reverse(filter(files, 'filereadable(v:val)'))
  source `=i`
 endfor
endfunction
