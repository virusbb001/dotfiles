let s:vim_files_dir = "~/dotfiles/vim/"

function! LoadSettingFiles(file_list)
 if type(a:file_list) != type([])
  echoerr "file_list must be list"
  return
 endif

 for l:file in a:file_list
  let l:filename=has_key(l:file, 'unbase') ?
     \ expand(l:filename["filename"]) :
     \ expand(s:vim_files_dir . l:file["filename"])
  if l:file["load"]
   if filereadable(l:filename)
    execute 'source '.l:filename
   else
    echohl WarningMsg
    echo "this file is unreadable: ".l:filename
    echohl None
   endif
  endif
 endfor
endf
