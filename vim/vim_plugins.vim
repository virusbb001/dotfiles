scriptencoding utf-8

if v:version < 704
  echohl WarningMsg
  echo "Vim's version is under 7.4"
  echo 'plz upgrade vim'
  echohl None
  finish
end

let s:dotfiles_vim_dir=expand('<sfile>:p:h')

augroup VirusVimPlugins
  autocmd!
augroup END

let s:dein_dir_name = 'dein'

" auto install
let s:dein_dir=expand('~/.vim/' .. s:dein_dir_name .. '/' . (has('nvim') ? 'nvim' : 'vim'))
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  " ask install or finish
  echo 'dein not detected'
  if !executable('git')
    echo "You have to install git first"
    finish
  endif

  let s:answer=confirm('Do you wanna install?', "&Yes\n&No")
  if s:answer == 2
    echo "OK, don't forget to comment out this script"
    finish
  endif
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

let &runtimepath = s:dein_repo_dir . ',' . &runtimepath

filetype plugin indent off

function! LoadRCVim(name) abort
  let l:filename = s:dotfiles_vim_dir . '/' . a:name
  echomsg l:filename
  execute 'source ' . l:filename
endfunction

let s:support_treesitter = has('nvim-0.5.0')
let s:support_lspbuiltin = has('nvim-0.5.0')

if dein#load_state(s:dein_dir)
  " vim_tomls
  " Required:
  call dein#begin(s:dein_dir,[$MYVIMRC, expand('<sfile>')])

  let s:directory = s:dotfiles_vim_dir
  call dein#load_toml(expand(s:directory . '/dein.toml'), {'lazy' : 0})
  call dein#load_toml(expand(s:directory . '/dein_lazy.toml'), {'lazy' : 1})
  call dein#load_toml(expand(s:directory . '/dein/nvim.toml'), { 'if': has('nvim') })
  call dein#load_toml(expand(s:directory . '/dein/filetypes.toml'), { 'lazy': 1, 'merge_ftdetect': 1 })
  call dein#load_toml(expand(s:directory . '/dein/ddu.toml'), { 'lazy': 1, 'on_source': 'ddu.vim' })
  if v:false
    call dein#load_toml(expand(s:directory . '/dein/deoplete.toml'), {'lazy' : 0})
  endif
  if s:support_lspbuiltin
    call dein#load_toml(expand(s:directory . '/dein/lsp_builtin.toml'), {'lazy' : 1})
  else
    call dein#load_toml(expand(s:directory . '/dein/non_lsp_builtin.toml'), {'lazy' : 1})
  endif

  if s:support_treesitter
    call dein#load_toml(expand(s:directory . '/dein/tree_sitter.toml'), {'lazy' : 0})
  else
    call dein#load_toml(expand(s:directory . '/dein/non_tree_sitter.toml'), {'lazy' : 1})
  endif

  if filereadable(expand('~/.vim/dein.toml'))
    call dein#load_toml(expand('~/.vim/dein.toml'), {'lazy' : 0})
  endif
  if filereadable(expand('~/.vim/dein_lazy.toml'))
    call dein#load_toml(expand('~/.vim/dein_lazy.toml'), {'lazy' : 1})
  endif

  if dein#tap('deoplete.nvim') && has('nvim')
    call dein#disable('neocomplete.vim')
  endif

  call dein#set_hook('denite.nvim', 'hook_source', 'call LoadRCVim("denite.rc.vim")')

  " Required:
  call dein#end()
  call dein#save_state()
end

if s:support_lspbuiltin
  execute 'luafile ' . expand(s:dotfiles_vim_dir . '/dein/lsp_settings.lua')
endif

call dein#call_hook('source')

" Required:
filetype plugin indent on

function! InstallMissedPlugin()
  if dein#check_install()
    call dein#install()
  endif
endfunction

if v:vim_did_enter
  call InstallMissedPlugin()
else
  autocmd VirusVimPlugins VimEnter * call dein#call_hook('post_source')
  autocmd VirusVimPlugins VimEnter * call InstallMissedPlugin()
endif

colorscheme tokyonight-night
