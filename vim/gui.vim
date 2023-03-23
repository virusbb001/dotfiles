scriptencoding utf-8
set ambiwidth=single
set title

if has('mac')
  nmap ¥ \
  imap ¥ \
  cmap ¥ \
  tmap ¥ \
endif

tnoremap <C-;> <C-\><C-n>
tnoremap <S-Space> <Space>

noremap <LeftMouse> <Nop>
inoremap <LeftMouse> <Nop>
tnoremap <LeftMouse> <Nop>
