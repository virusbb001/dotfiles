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

  require('neodev').setup({
  });

  local augroup = "VirusLspAugroup"

  vim.api.nvim_create_augroup(augroup, {
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

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

    end,
  })

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = {
    'pyright',
    'angularls',
    'eslint',
    'html',
    'clangd'
  }

  local base_lsp_settings = {
    capabilities = lsp_status.capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }

  local function base_lsp_with (cfg)
    return vim.tbl_deep_extend("force", base_lsp_settings, cfg)
  end

  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup(base_lsp_settings)
  end

  local detect_deno_root_dir = function (filename, bufnr)
    if (bufnr ~= nil) then
      local firstline = vim.fn.getbufline(bufnr, 1)[1] or ""
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

  nvim_lsp.denols.setup(base_lsp_with({
    root_dir = detect_deno_root_dir
  }))

  nvim_lsp.tsserver.setup(base_lsp_with({
    root_dir = detect_node_root_dir,
    handlers = {
      ["textDocument/publishDiagnostics"] = function(
        _,
        result,
        ctx,
        config
      )
        if result.diagnostics == nil then
          return
        end

        -- ignore some tsserver diagnostics
        local idx = 1
        while idx <= #result.diagnostics do
          local entry = result.diagnostics[idx]

          local formatter = require('format-ts-errors')[entry.code]
          entry.message = formatter and formatter(entry.message) or entry.message

          -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
          if entry.code == 80001 then
            -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
            table.remove(result.diagnostics, idx)
          else
            idx = idx + 1
          end
        end

        vim.lsp.diagnostic.on_publish_diagnostics(
          _,
          result,
          ctx,
          config
        )
      end,
    }
  }))

  local function virus_lsp_after_denops ()
    nvim_lsp.jsonls.setup {
      capabilities = lsp_status.capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        }
      }
    }
    -- TODO: enable jsonls opened buffer
  end

  vim.fn['denops#plugin#wait_async']('virus_dotfiles', virus_lsp_after_denops)

  nvim_lsp.rust_analyzer.setup(base_lsp_with({
    cmd = {"rustup", "run", "stable", "rust-analyzer"},
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          targets = {
            "x86_64-pc-windows-gnu",
            "x86_64-unknown-linux-gnu"
          },
        },
        procMacro = {
          enable = true,
        },
        cargo = {
          features = "all",
        }
      }
    }
  }))

  nvim_lsp.lua_ls.setup(base_lsp_with({
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
      }
    }
  }))

  nvim_lsp.cssls.setup(base_lsp_with({
    settings = {
      css = {
        -- TODO: should I check that project do not uses postcss and change to true?
        validate = false
      }
    }
  }))

  nvim_lsp.phpactor.setup(base_lsp_with({
  }))

end
