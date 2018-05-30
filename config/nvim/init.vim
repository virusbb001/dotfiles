set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if filereadable(expand("$HOME/_vimrc"))
  source ~/_vimrc
endif

if filereadable(expand("$HOME/.vimrc"))
  source ~/.vimrc
endif
