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
" }}}
