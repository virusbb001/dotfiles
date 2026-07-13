import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

export default function getNvimPlugins (): Plugin[] {
  // plugins that other plugins depend
  const depends: RemotePlugin[] = [{
    repo: "MunifTanjim/nui.nvim"
  }, {
    repo: "nvim-lua/plenary.nvim",
    lazy: true
  }];

  const nvimOnly: RemotePlugin[] = [{
    repo: "andythigpen/nvim-coverage",
    depends: ['plenary.nvim'],
    on_event: 'BufRead',
    lazy: true,
    lua_post_source: `require("coverage").setup()`
  }, {
      repo: 'theHamsta/nvim_rocks',
      lazy: true,
      on_event: 'VimEnter',
      extAttrs: {
        // TODO: check inside virtualenv
        installerBuild: 'pip3 install user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua'
      },
      lua_post_source: `
-- for nvim-coverage
-- nvim_rocks.ensure_installed('lua-xmlreader')
`
    }, {
      repo: 'oflisback/obsidian-bridge.nvim',
      lazy: true,
      if: 'exists("$OBSIDIAN_REST_API_KEY")',
      on_ft: ['markdown'],
      depends: ['plenary.nvim'],
      lua_post_source: `require("obsidian-bridge").setup()`
    }, {
      repo: "bfredl/nvim-luadev",
      on_cmd: ["Luadev"],
      on_map: "<Plug>(Luadev-",
      hook_add: `
nmap <Leader>ldl <Plug>(Luadev-RunLine)
nmap <Leader>ldr <Plug>(Luadev-Run)
nmap <Leader>ldw <Plug>(Luadev-RunWord)
      `
    }, {
      repo: 'linrongbin16/gitlinker.nvim',
      lua_source: `require('gitlinker').setup()`
    }, {
      repo: 'NotAShelf/direnv.nvim',
      if: 'executable("direnv")',
      lua_source: `require("direnv").setup({})`
    }]

  return depends.concat(nvimOnly).map((v): Plugin => ({
    ...addName(v)
  }));
}
