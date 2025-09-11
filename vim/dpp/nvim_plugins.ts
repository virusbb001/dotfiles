import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";

export default function getNvimPlugins (): Plugin[] {
  // plugins that other plugins depend
  const depends: RemotePlugin[] = [{
    repo: "MunifTanjim/nui.nvim"
  }, {
    repo: "nvim-lua/plenary.nvim"
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
        installerBuild: 'pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua'
      },
      lua_post_source: `
-- for nvim-coverage
nvim_rocks.ensure_installed('lua-xmlreader')
`
    }, {
      repo: 'oflisback/obsidian-bridge.nvim',
      lazy: true,
      if: 'exists("$OBSIDIAN_REST_API_KEY")',
      on_ft: ['markdown'],
      depends: ['plenary.nvim'],
      lua_post_source: `require("obsidian-bridge").setup()`
    }]

  return depends.concat(nvimOnly).map((v): Plugin => ({
    ...addName(v),
    lazy: true
  }));
}
