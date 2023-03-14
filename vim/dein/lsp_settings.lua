function virus_null_ls_settings ()
  local null_ls = require('null-ls')
  local sources = {
  }

  null_ls.setup({ sources = sources })
end

function _G.virus_lsp_settings ()
  -- lspconfig is not set when defined this function
  local nvim_lsp = require('lspconfig')
  local util = require('lspconfig/util')

  local lsp_status = require('lsp-status')
  lsp_status.config({
    indicator_errors = 'E',
    indicator_warnings = 'W',
    indicator_ok = 'Ok',
  })
  lsp_status.register_progress()

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  end

-- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = {
    'pyright',
    'rust_analyzer',
    'angularls',
    'eslint',
    'html',
    'cssls',
    'clangd'
  }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = lsp_status.capabilities,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  local detect_deno_root_dir = function (filename, bufnr)
    if (bufnr ~= nil) then
      local firstline = vim.fn.getbufline(bufnr, 1)[1]
      -- detect from shebang
      local is_shebang = string.sub(firstline, 1, 2) == "#!"
      if is_shebang and string.match(firstline, "deno") then
        return util.path.dirname(filename)
      end
    end
    return util.root_pattern('deno.json', 'deno.jsonc')(filename)
  end

  local detect_node_root_dir = function(filename, bufnr)
    local is_deno = detect_deno_root_dir(filename, bufnr)
    if is_deno then
      return nil
    end
    return util.root_pattern('package.json', 'tsconfig.json')(filename)
  end

  nvim_lsp.denols.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = detect_deno_root_dir
  }
  nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    root_dir = detect_node_root_dir
  }

  local function virus_lsp_after_denops ()
    local json_scheme = vim.fn.json_decode(vim.fn['denops#request']( 'virus_dotfiles', 'checkAndFetchJsonScheme', { vim.fn.stdpath('cache') }))
    nvim_lsp.jsonls.setup {
      on_attach = on_attach,
      capabilities = lsp_status.capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        json = json_scheme
      }
    }
    -- TODO: enable jsonls opened buffer
  end

  vim.fn['denops#plugin#wait_async']('virus_dotfiles', virus_lsp_after_denops)
end
