-- lua_add {{{
vim.g.user_emmet_settings = {
  variables = {
    lang = "ja"
  },
  vue = {
    filters = "html",
  },
}
local emmet = "<Plug>(dotfiles-emmet)"
vim.g.user_emmet_leader_key = emmet
vim.keymap.set({'i'}, "<Plug>(dotfiles-emmet)<C-Y>", "<Nop>")
vim.keymap.set({'i'}, "<Plug>(dotfiles-emmet)<Esc>", "<Nop>")
-- }}}
