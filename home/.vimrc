" .vimrc

scriptencoding utf-8

let s:dotfiles_dir = '~/dotfiles/'

let s:vim_files=[
   \s:dotfiles_dir . 'vim/vim_settings.vim',
   \s:dotfiles_dir . 'vim/vim_plugins.vim',
   \'~/.vim/local_settings.vim'
   \]

for s:file in s:vim_files
 let s:path = expand(s:file)
 if filereadable(s:path)
  execute 'source '.s:path
 endif
endfor

let $PATH = $PATH . ':/home/virus/.virtualenvs/dev/bin'
set background=dark
colorscheme gruvbox

" vim: set ft=vim :
