local my_util = require("my_util")
return {
  root_dir = my_util.detect_node_root_dir,
  workspace_required = true,
  handlers = {
    ["textDocument/publishDiagnostics"] = function(
      _,
      result,
      ctx
    )
    if result.diagnostics == nil then
      return
    end

    -- ignore some ts_ls diagnostics
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
      ctx
    )
  end,
  },
  init_options = {
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayVariableTypeHintsWhenTypeMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true
    }
  }
}
