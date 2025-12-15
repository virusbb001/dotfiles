-- lua_source {{{
local config = vim.fs.joinpath(vim.fn.expand("$DOTFILES_BASE_DIR"), "rc/ddc_config.ts");
vim.call("ddc#custom#load_config", config)

vim.keymap.set({'i'}, "<C-x>c", "ddc#map#manual_complete()", {
  expr = true,
  remap = false,
})

vim.call("ddc#enable");
--- }}}
