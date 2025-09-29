-- lua_source {{{

require("mason").setup()

local mason_registry = require("mason-registry")
-- ensure install
local pkgs = {
  "markdown-oxide",
  "textlint"
}

local not_installed = vim.tbl_filter(function(item)
  return not mason_registry.is_installed(item)
end, pkgs)
if not vim.tbl_isempty(not_installed) then
  vim.cmd{
    cmd='MasonInstall',
    args = not_installed
  }

end

-- }}}
