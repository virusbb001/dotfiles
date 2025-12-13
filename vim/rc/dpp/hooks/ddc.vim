" hook_source {{{
call ddc#custom#patch_global('ui', 'native')

call ddc#custom#patch_global('sources', ['around', 'lsp'])

call ddc#custom#patch_global('sourceOptions', #{
      \ around: #{ mark: 'A' },
      \})

call ddc#custom#patch_global('sourceParams', #{
      \ around: #{ maxSize: 500 },
      \})

call ddc#custom#patch_global('sourceOptions', #{
      \ _: #{
      \     matchers: ['matcher_head'],
      \     sorters: ['sorter_rank'],
      \ }},
      \ )


inoremap <expr> <C-x>c ddc#map#manual_complete()

call ddc#enable()
" }}}
