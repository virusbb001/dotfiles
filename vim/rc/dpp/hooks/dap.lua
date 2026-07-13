-- lua_source {{{
local dap = require("dap")
local lldb_dap = vim.fn.exepath("lldb-dap")
dap.adapters.lldb = {
  type = "executable",
  command = lldb_dap,
  name = "lldb"
}

dap.adapters.ruby = function (callback, config)
  callback {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "bundle",
      args = {
        "exec", "rdbg", "-n", "--open", "--port", "${port}",
        "-c", "--", "bundle", "exec", config.command, config.script,
      },
    },
  }
end

dap.adapters["js-debug"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug",
    args = {"${port}"}
  }
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

dap.configurations.ruby = {
  {
    type = "ruby",
    name = "debug current file",
    request = "attach",
    localfs = true,
    command = "ruby",
    script = "${file}"
  },
  {
    type = "ruby",
    name = "debug current spec file",
    request = "attach",
    localfs = true,
    command = "rspec",
    script = "${file}"
  }
}

local js_debug_config = {
  {
    type = "js-debug",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd ="${workspaceFolder}",
    sourceMaps = true,
    smartStep = true,
    runtimeArgs = {"--import", "tsx"}
  }
}

dap.configurations.javascript = js_debug_config
dap.configurations.typescript = js_debug_config

-- `:h dap-terminal`
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
-- }}}
