" common setting
set encoding=utf-8
scriptencoding utf-8

"表示関係
" set number
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
set statusline+=%l/%L,%c%V%5P

set concealcursor=nc

set ruler
syntax enable

"エンコード関連
"termencodingがなければ設定
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
" 折りたたみを閉じる
set foldlevelstart=0

"UNDO関連
set undolevels=1000
if has('persistent_undo')
 let s:undodir = $HOME . '/.vim/undo'
 if !isdirectory(s:undodir) && exists('*mkdir')
  call mkdir(s:undodir, 'p')
 endif
 let &undodir=s:undodir
 "set undodir=~/.vim/undo
 set undofile
endif

"検索
set ignorecase
set smartcase
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
"インデント
set autoindent
"set smartindent
set shiftwidth=2

"その他
set modeline
set modelines=5
set noinsertmode
set backspace=2
set whichwrap=b,s,h,l,<,>,[,]
set autoread
set wildmenu
set wildmode=list:longest,full
set history=100
filetype plugin indent on
if &encoding ==? 'utf-8'
 set ambiwidth=double
endif

"マウスを無効に
set mouse=
set hidden
set completeopt=menuone,preview,longest

if has('vim_starting')
 let &runtimepath.=',' . expand('$VIMRUNTIME')
endif

"キー設定
nmap <F1> <Nop>

noremap <special> <SID>win_inc_height <C-w>+
noremap <special> <SID>win_dec_height <C-w>-
noremap <special> <SID>win_inc_width <C-w>>
noremap <special> <SID>win_dec_width <C-w><

nmap <special> <SID>win_repeat+ <SID>win_inc_height<SID>win_repeat
nmap <special> <SID>win_repeat- <SID>win_dec_height<SID>win_repeat
nmap <special> <SID>win_repeat> <SID>win_inc_width<SID>win_repeat
nmap <special> <SID>win_repeat< <SID>win_dec_width<SID>win_repeat

nnoremap <special> <SID>win_repeat <C-w>

nmap <special> <C-w>+ <SID>win_repeat+
nmap <special> <C-w>- <SID>win_repeat-
nmap <special> <C-w>> <SID>win_repeat>
nmap <special> <C-w>< <SID>win_repeat<

tnoremap <S-Space> <Space>

nmap <Space> <Plug>[Space]
nnoremap <Plug>[Space] <Nop>

"自動コマンド
augroup VirusDropboxAuto
 autocmd!
 autocmd FileType perl,cgi compiler perl
 autocmd BufRead,BufNewFile *.gradle set filetype=groovy
 autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
 autocmd FileType html compiler tidy
 " gnu-emacs yesでエラーメッセージをそれっぽく
 autocmd FileType html setlocal makeprg=tidy\ -quiet\ -errors\ -raw\ -xml\ --gnu-emacs\ yes\ \"%\"
 " rubyの時インデントを2に
 autocmd BufRead,BufNewFile *.rb setlocal shiftwidth=2 tabstop=2 expandtab
 autocmd BufRead,BufNewFile *.yaml setlocal shiftwidth=2 tabstop=2 expandtab
 autocmd FileType mkd,markdown setlocal noexpandtab
 autocmd FileType help setlocal iskeyword+=-
 autocmd FileType python setlocal colorcolumn=80
 if exists('##TermOpen')
   autocmd TermOpen * setlocal statusline=%{b:term_title}%=PID:%{b:terminal_job_pid},%c_%l/%L
 endif
augroup END

"file name:.vimrc.local
"
function! s:vimrc_local(loc)
 let l:files = findfile('.vimrc.local',escape(a:loc,' ').';',-1)
 for l:i in reverse(filter(l:files, 'filereadable(v:val)'))
  source `=i`
 endfor
endfunction

if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" markdown syntax
" see markdown syntax file or http://mattn.kaoriya.net/software/vim/20140523124903.htm
let g:markdown_fenced_languages = [
   \ 'javascript',
   \ 'js=javascript',
   \ 'cpp',
   \ 'ruby',
   \ 'lua'
   \]
