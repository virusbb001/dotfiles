-- lua_post_source {{{
local treesitter = require'nvim-treesitter'
treesitter.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

treesitter.install {
  'javascript',
  'rust',
  'slim',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

local augroup = "VirusTSAugroup"

vim.api.nvim_create_augroup(augroup, {
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'javascript',
    'rust',
    'slim',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
  callback = function(ev)
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    print(string.format('event fired: %s', vim.inspect(ev)))

    if vim.treesitter.query.get("rust", "indents") then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})
-- }}}
