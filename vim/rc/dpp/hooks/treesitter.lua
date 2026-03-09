-- lua_post_source {{{
local treesitter = require'nvim-treesitter'
treesitter.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

local required = {
  'javascript',
  'rust',
  'slim',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
  'nix',
  -- bennypowers/nvim-regexplainer
  'regex'
}
-- convert from ts name to filetype
local filetypemap = {
  vimdoc = "help"
}

local filetype = {}
for _, lang in ipairs(required) do
  local ft = filetypemap[lang]
  if ft then
    table.insert(filetype, ft)
  else
    table.insert(filetype, lang)
  end
end

local installed = treesitter.get_installed()

local required_table = {}
local missings = {}
for _, lang in ipairs(required) do
  required_table[lang] = true
end
for _, lang in ipairs(installed) do
  required_table[lang] = false
end
for k, v in pairs(required_table) do
  if v then
    table.insert(missings, k)
  end
end

treesitter.install(missings)

local augroup = "VirusTSAugroup"

vim.api.nvim_create_augroup(augroup, {
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetype,
  callback = function(ev)
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    if vim.treesitter.query.get(ev["match"], "indents") then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})

-- TODO: start treesitter when sourced

-- }}}
