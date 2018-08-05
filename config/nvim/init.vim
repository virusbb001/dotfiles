set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if filereadable(expand('$HOME/_vimrc'))
  source ~/_vimrc
endif

if filereadable(expand('$HOME/.vimrc'))
  source ~/.vimrc
endif

if exists('g:nyaovim_version') && filereadable(expand('$HOME/.gvimrc'))
  source ~/.gvimrc
endif

tnoremap <silent> <Esc> <C-\><C-n>
tnoremap <C-\><Esc> <Esc>
tnoremap <C-w> <C-\><C-N><C-w>
