scriptencoding utf-8

" dpp uses denops so deno should be installed

if ! executable('deno')
  echohl WarningMsg
  echomsg "deno should be installed"
  echohl None
  finish
endif

if ! executable('git')
  echohl WarningMsg
  echomsg "git should be installed"
  echohl None
  finish
endif

const s:dotfiles_vim_dir=expand('<sfile>:p:h')
let $DOTFILES_BASE_DIR = s:dotfiles_vim_dir
const s:dpp_config = expand(s:dotfiles_vim_dir .. "/rc/dpp_config.ts")

const s:plugins_data_json = expand(s:dotfiles_vim_dir .. "/rc/dpp/dpp_plugins.json")
const s:plugins_data = json_decode(readfile(s:plugins_data_json))

" no trail slash
const s:dpp_base = expand(stdpath("cache") .. "/dpp")
const s:dpp_github_repos = s:dpp_base .. "/repos/github.com"

function! InstallAndAddPlugin (github_repo)
  const dir = expand(s:dpp_github_repos .. "/" .. a:github_repo)
  if ! isdirectory(dir)
    const github_url = "https://github.com/" .. a:github_repo .. ".git"
    execute "!git clone" github_url dir
  endif
  execute 'set runtimepath^=' .. dir->fnamemodify(":p")->substitute('[/\\]$', '', '')
endfunction

for s:minimal_plugin in s:plugins_data["minimal"]
  call InstallAndAddPlugin(s:minimal_plugin)
endfor

if dpp#min#load_state(s:dpp_base)
  for s:install_plugin in s:plugins_data["install"]
    call InstallAndAddPlugin(s:install_plugin)
  endfor

  " turn on when --noplugin
  " runtime! plugin/denops.vim

  autocmd User DenopsReady
  \ : echohl Warning
  \ | echomsg "dpp load_state() is failed"
  \ | echohl None
  \ | call dpp#make_state(s:dpp_base, s:dpp_config)
else
  autocmd User DenopsReady call s:check_files()
endif

function s:completeMakeState ()
  echohl Warning
  echomsg "dpp make_state() is done"
  echohl None
  " make_stateした後ではgetNotInstalledに反映されないらしい
  if ! dpp#sync_ext_action('installer', 'getNotInstalled')->empty()
    call dpp#async_ext_action("installer", "install")
  endif
endfunction

filetype indent plugin on

if has('syntax')
  syntax on
endif

augroup VirusVimPlugins
  autocmd!
augroup END

autocmd VirusVimPlugins User Dpp:makeStatePost call s:completeMakeState()

function! s:check_files (filename = v:null)
  if a:filename != v:null && stridx(a:filename, s:dotfiles_vim_dir) != 0
    return
  endif
  if !dpp#check_files()->empty()
    call dpp#make_state()
  endif
endfunction

autocmd VirusVimPlugins BufWritePost *.lua,*.vim,*.ts call s:check_files(expand("<afile>:p"))

colorscheme tokyonight-night

if has('nvim')
  " TODO: source when lspsettings sourced
  execute 'luafile ' . expand(s:dotfiles_vim_dir . '/rc/lsp_settings.lua')
  lua require 'nvim_settings'
endif
