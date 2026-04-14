-- lua_source {{{
local dap = require("dap")
local lldb_dap = vim.fn.exepath("lldb-dap")
dap.adapters.lldb = {
  type = "executable",
  command = lldb_dap,
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    console = "integratedTerminal",
    initCommands = {
      --  https://lldb.llvm.org/use/map.html#ignore-a-function-when-doing-a-source-level-single-step-in
      "settings set target.process.thread.step-avoid-regexp ^std::"
    }
  }
}
-- `:h dap-terminal`
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
-- }}}
