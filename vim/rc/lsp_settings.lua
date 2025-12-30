---
---wait markdown oxide client initialize.
---don't use coroutine because on_init is called c thread,
---caused attempt to yield across a c-call boundary
---@param cb fun(client: vim.lsp.Client)
---
local function wait_markdown_oxide_client(cb)
  local server_name = "markdown_oxide"
  local buffer_clients = vim.lsp.get_clients({bufnr = 0})
  ---@type (nil | vim.lsp.Client)
  local buffer_oxide_client = vim.iter(buffer_clients):find(function(client)
    return client.name == server_name
  end)

  if buffer_oxide_client then
    cb(buffer_oxide_client)
  end

  local default_path = vim.g.obsidian_default_vault_path
  if default_path == nil then
    error("g:obsidian_default_vault_path should be defined")
  end

  ---@type vim.lsp.Config
  local cfg_patch = {
    root_dir = default_path,
    on_init = cb
  }
  local lsp_config = vim.tbl_deep_extend('keep',cfg_patch, vim.lsp.config.markdown_oxide)
  local id = vim.lsp.start(lsp_config, {
    attach = false
  })
  if id == nil then
    error("vim.lsp.start returned nil")
  end
  local client = vim.lsp.get_client_by_id(id)
  if client == nil then
    error("failed to start " .. server_name)
  end
  if client.initialized then
    cb(client)
  end
end

local function setupDailyCommand ()
  vim.api.nvim_create_user_command("Daily", function (daily_args)
    local dpp = require("dpp")
    -- load lspconfig to get markdon_oxide config
    dpp.source({"nvim-lspconfig"})

    local input = daily_args.args
    if input == "" then
      input = "today"
    end
    -- if buffer has attached markdown_oxide, use attached client
    wait_markdown_oxide_client(function(client)
      if client == nil then
        return
      end

      vim.lsp.log.warn("executing command jump")
      client:exec_cmd({
        command="jump",
        arguments={input}
      })
    end)
  end, {
    desc = 'Open daily note',
    nargs = "*",
    bang = true
  })
end
setupDailyCommand()

function _G.virus_lsp_settings ()
  -- lspconfig is not set when defined this function

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

      lsp_status.on_attach(client)

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

      -- markdown-oxide
      --[[
      if client and client.name == "markdown_oxide" then
        vim.api.nvim_buf_create_user_command(
          0,
          "Daily",
          function (daily_args)
            local input = daily_args.args
            if input == "" then
              input = "today"
            end

            client:exec_cmd({
              command="jump",
              arguments={input}
            })
          end,
          {
            desc = 'Open daily note',
            nargs = "*"
          }
        )
      end
      ]]
    end,
  })

  local ddc_source_lsp = require("ddc_source_lsp");
  -- new version LSP settings
  vim.lsp.config('*', {
    capabilities = vim.tbl_deep_extend("force", lsp_status.capabilities, ddc_source_lsp.make_client_capabilities()),
    flags = {
      debounce_text_changes = 150,
    }
  });


  vim.lsp.enable({
    'lua_ls',
    'rust_analyzer',
    'pyright',
    -- 'angularls',
    'eslint',
    'html',
    'clangd',
    'jsonls',
    'cssls',
    'denols',
    'ts_ls',
    'markdown_oxide',
    'nil_ls'
  })
end

-- https://github.com/neovim/neovim/issues/30908#issuecomment-2657220629
local function virtual_text_document(params)
  local bufnr = params.buf
  local actual_path = params.match:sub(1)

  local clients = vim.lsp.get_clients({ name = "denols" })
  if #clients == 0 then
    return
  end

  local client = clients[1]
  local method = "deno/virtualTextDocument"
  local req_params = { textDocument = { uri = actual_path } }
  local response = client:request_sync(method, req_params, 2000, 0)
  if not response or type(response.result) ~= "string" then
    return
  end

  local lines = vim.split(response.result, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
  vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, actual_path)
  vim.lsp.buf_attach_client(bufnr, client.id)

  local filetype = "typescript"
  if actual_path:sub(-3) == ".md" then
    filetype = "markdown"
  end
  vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
end

vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "deno:/*" },
  callback = virtual_text_document,
})
