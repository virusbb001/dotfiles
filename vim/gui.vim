scriptencoding utf-8
set ambiwidth=single
set title

if has('mac')
  nmap ¥ \
  imap ¥ \
  cmap ¥ \
  tmap ¥ \

  let s:path = system("echo echo VIMPATH'${PATH}' | $SHELL -l")
  let $PATH = matchstr(s:path, 'VIMPATH\zs.\{-}\ze\n')
endif

tnoremap <C-;> <C-\><C-n>
tnoremap <S-Space> <Space>

noremap <LeftMouse> <Nop>
inoremap <LeftMouse> <Nop>
tnoremap <LeftMouse> <Nop>
