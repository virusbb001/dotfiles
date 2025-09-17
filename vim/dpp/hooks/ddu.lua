-- lua_source {{{
local config = vim.fs.joinpath(vim.fn.expand("$DOTFILES_BASE_DIR"), "rc/ddu_config.ts");
vim.call("ddu#custom#load_config", config)
--- }}}
