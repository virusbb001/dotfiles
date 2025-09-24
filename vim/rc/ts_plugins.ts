import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

export default function getTSPlugins (): Plugin[] {
  const main: RemotePlugin[] = [{
    repo: "nvim-treesitter/nvim-treesitter",
    rev: "main",
    on_event: ['BufRead', 'CursorHold', 'FileType'],
    hook_post_update: "TSUpdate",
    hooks_file: path.join(import.meta.dirname!, "hooks/treesitter.lua")
  }];

  const additional: RemotePlugin[] = [{
    repo: 'cshuaimin/ssr.nvim',
    depends: ['nvim-treesitter'],
    lazy: true,
    on_source: ['nvim-treesitter'],
    hooks_file: path.join(import.meta.dirname!, "hooks/ssr.nvim.lua")
  }, {
      repo: 'bennypowers/nvim-regexplainer',
      depends: ['nvim-treesitter', 'nui.nvim'],
      lazy: true,
      on_source: ['nvim-treesitter'],
      lua_source: `require'regexplainer'.setup()`
    }]

  const plugins = main.concat(additional);

  return plugins.map(p => {
    return addName({
      ...p,
    })
  });
}
