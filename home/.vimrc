" .vimrc

scriptencoding utf-8

" TODO: replace
let s:dotfiles_dir = '~/dotfiles/'

" local_settings.vim: settings before loading plugin
"   e.g.: python remote plugin
" local_settings_after: settings after loaded plugin (maybe it is not
" necessary?)

let s:vim_files=[
   \'~/.vim/local_settings.vim',
   \s:dotfiles_dir . 'vim/vim_settings.vim',
   \s:dotfiles_dir . 'vim/vim_plugins.vim',
   \'~/.vim/local_settings_after.vim',
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
