" hook_add {{{
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
tmap <C-j> <Plug>(skkeleton-toggle)
" }}}

" hook_source {{{
function! s:skkeleton_init() abort
  let s:dict_location = dpp#get('skk-dict')['path']
  call skkeleton#config(#{
    \ globalDictionaries: [
    \     expand(s:dict_location .. '/SKK-JISYO.L')
    \ ]
    \ })
endfunction
augroup skkeleton-intialize-pre
  autocmd!
  autocmd User skkeleton-initialize-pre call s:skkeleton_init()
augroup END
" }}}
