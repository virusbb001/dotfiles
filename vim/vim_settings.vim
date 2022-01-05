" common setting
set encoding=utf-8
scriptencoding utf-8

set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set number
set nonumber
set showmode
set listchars=tab:>-,eol:$,nbsp:-
set list
set cursorline
set showcmd
set wrap
set hlsearch
set showtabline=2
set laststatus=2
function! LspStatus() abort
  " This function will overwrite in lsp-status settings.
  return ''
endfunction
"左
set statusline=%f[B-No.%n]%r%y\|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m
set statusline+=%=
"右
set statusline+=%{LspStatus()}%l/%L,%c%V%5P

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

"about key settings
set notimeout
set ttimeout
set timeoutlen=100
"インデント
set autoindent
"set smartindent
set shiftwidth=2

"その他
set modeline
set modelines=5
set noinsertmode
set backspace=indent,eol,start
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
map Q gQ

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

nnoremap <expr> n (v:searchforward ? 'n' : 'N')
nnoremap <expr> N (v:searchforward ? 'N' : 'n')

tnoremap <S-Space> <Space>

nmap <Space> <Plug>[Space]
nnoremap <Plug>[Space] <Nop>

if has('nvim')
  function! RotateTermBuffer(incnum) abort
    let l:chans = nvim_list_chans()
    call filter(l:chans, { idx, val -> val["mode"] ==# "terminal" && strlen(val["pty"]) > 0 })
    call sort(l:chans, { a, b -> a['buffer'] - b['buffer']})
    let currentBuf = bufnr('%')
    let l:index = -1
    let l:i = 0
    let l:chansLen = len(l:chans)
    while l:i < l:chansLen
      if l:chans[l:i]['buffer'] == currentBuf
        let l:index = l:i
        break
      endif
      let l:i = l:i + 1
    endwhile
    let l:target = (l:index + a:incnum)
    while l:target < 0
      let l:target = l:target + l:chansLen
    endwhile
    let l:bufnr = l:chans[l:target % l:chansLen]['buffer']
    execute 'edit' '#' . l:bufnr
  endfunction
else
  function! RotateTermBuffer(incnum) abort
    throw 'Not Implemented yet'
  endfunction
endif

" terminal buffer setting
function! s:setTermSetting() abort
  setlocal statusline=%{b:term_title}%=PID:%{b:terminal_job_pid},%c_%l/%L
  nnoremap <buffer> <C-n> :<C-u>call RotateTermBuffer(v:count1)<CR>
  nnoremap <buffer> <C-p> :<C-u>call RotateTermBuffer(-1 * v:count1)<CR>
endfunction

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
   autocmd TermOpen * call s:setTermSetting()
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
