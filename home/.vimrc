" .vimrc

scriptencoding utf-8

let s:dotfiles_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

" local_settings.vim: settings before loading plugin
"   e.g.: python remote plugin
" local_settings_after: settings after loaded plugin (maybe it is not
" necessary?)

let s:vim_files=[
   \'~/.config/home-manager/vim/local.vim',
   \s:dotfiles_dir . "/" . 'vim/vim_settings.vim',
   \s:dotfiles_dir . "/" . 'vim/vim_plugins.vim',
   \'~/.vim/local_settings_after.vim',
   \]

for s:file in s:vim_files
 let s:path = expand(s:file)
 if filereadable(s:path)
  execute 'source '.s:path
 endif
endfor
