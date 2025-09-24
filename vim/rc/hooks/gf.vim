" hook_add {{{
function! GfFile()
  let path = expand('<cfile>')
  let line = 0
  if path =~# ':\d\+:\?$'
    let line = matchstr(path, '\d\+:\?$')
    let path = matchstr(path, '.*\ze:\d\+:\?$')
  endif
  if !filereadable(path)
    return 0
  endif
  return {
  \   'path': path,
  \   'line': line,
  \   'col': 0,
  \ }
endfunction
call gf#user#extend('GfFile', 1000)
" }}}
