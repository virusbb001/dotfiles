" hook_source {{{
inoremap <C-n> <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

imap <expr> <CR> pum#visible() ? "<C-y>" : "<CR>"

call pum#set_option(#{
      \ preview: v:true
      \})
" }}}
