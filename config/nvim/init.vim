set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if filereadable(expand('$HOME/_vimrc'))
  source ~/_vimrc
endif

if filereadable(expand('$HOME/.vimrc'))
  source ~/.vimrc
endif

if filereadable(expand('$HOME/.gvimrc'))
  let s:is_gui = exists('g:nyaovim_version') || exists('g:gui_oni')
  if s:is_gui
    source ~/.gvimrc
  endif
endif
