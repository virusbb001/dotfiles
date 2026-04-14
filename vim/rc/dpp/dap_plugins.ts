
import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

export default function getDapPlugins(): Plugin[] {
  /**
  const plugins: RemotePlugin[] = [{
    repo: 'user/plugin',
    hooks_file: path.join(import.meta.dirname!, "hooks/plugin.lua")
  }];
  */
  const plugins: RemotePlugin[] = [{
    repo: "mfussenegger/nvim-dap",
    hooks_file: path.join(import.meta.dirname!, "hooks/dap.lua")
  }, {
    repo: "nvim-neotest/nvim-nio"
  }, {
    repo: "rcarriga/nvim-dap-ui",
    depends: ["nvim-dap", "nvim-nio"],
    lua_source: `require("dapui").setup()`
  }]

  return plugins.map(addName);
}
