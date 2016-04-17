" base_dir
let s:vim_files_dir = "~/dotfiles/vim/"

let s:vim_files=[
   \    {
   \        "load": 1,
   \        "filename": "vim_settings.vim"
   \    },
   \    {
   \        "load": 1,
   \        "filename": "vim_plugins_1.vim"
   \    },
   \    {
   \        "load": 0,
   \        "filename": "vim_plugins_1.vim"
   \    },
   \]

function! LoadSettingFiles(file_list)
 if type(a:file_list) != type([])
  echoerr "file_list must be list"
  return
 endif

 for l:file in a:file_list
  let l:filename=expand(s:vim_files_dir . l:file["filename"])
  if filereadable(l:filename)
   if l:file["load"]
    execute 'source '.l:filename
   endif
  else
   echohl WarningMsg
   echo "this file is unreadable: ".l:filename
   echohl None
  endif
 endfor
endf

call LoadSettingFiles(s:vim_files)
