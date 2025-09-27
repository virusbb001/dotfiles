" hook_source {{{
function! DduToggleHidden()
  const current = ddu#custom#get_current(b:ddu_ui_name)
  const source_options = get(current, 'sourceOptions', {})
  const source_options_all = get(source_options, 'file', {})
  let matchers = get(source_options_all, 'matchers', [])->copy()
  const matchers_hidden_index = index(matchers, 'matcher_hidden')
  if matchers_hidden_index < 0
    let r = add(matchers, 'matcher_hidden')
    return r
  else
    call remove(matchers, matchers_hidden_index)
    return matchers
  endif
endfunction
" }}}

" ddu-filer {{{
nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> o
        \ <Cmd>call ddu#ui#do_action('expandItem',
        \ {'mode': 'toggle'})<CR>
nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('redraw')<CR>
nnoremap <buffer> .
      \ <Cmd>call ddu#ui#multi_actions([
      \ ['updateOptions', #{
      \   sourceOptions: #{
      \     file: #{
      \       matchers: DduToggleHidden()
      \     }
      \   }
      \ }],
      \ ['redraw', #{method: 'refreshItems' }]
      \ ])<CR>
" }}}
