call denite#custom#option('_', {
  \ 'mode': 'normal'
  \})

call denite#custom#map('normal', '<BS>', '<denite:jump_to_previous_source>')

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

" Add custom menus
let s:menus = {}


let s:menus.zsh = {
  \ 'description': 'Edit your import zsh configuration'
  \ }
let s:menus.zsh.file_candidates = [
  \ ['zshrc', '~/.config/zsh/.zshrc'],
  \ ['zshenv', '~/.zshenv'],
  \ ]

let s:menus.my_commands = {
  \ 'description': 'Example commands'
    \ }
let s:menus.my_commands.command_candidates = [
  \ ['Split the window', 'vnew'],
  \ ['Open zsh menu', 'Denite menu:zsh'],
  \ ['Running terms', 'Denite -input=term: buffer'],
  \ ['dotfiles', 'Denite file::' . escape(expand("<sfile>:p:h:h") , ':\')],
  \ ]

call denite#custom#var('menu', 'menus', s:menus)

function! DeniteOpenInTerm(context) abort
  let l:path=a:context.targets[0].action__path
  tab split
  execute 'lcd ' . l:path
  execute 'terminal xonsh'
endfunction

call denite#custom#action('directory', 'terminal', funcref('DeniteOpenInTerm'))
call denite#custom#action('directory', 'debug', {context -> execute('PP! context', '')})

