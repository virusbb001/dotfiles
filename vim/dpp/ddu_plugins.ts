import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

export default function getDDUPlugins (): Plugin[] {
  const ddu: RemotePlugin = {
    repo: 'Shougo/ddu.vim',
    depends: 'denops.vim',
    // may change source conditional
    on_source: 'denops.vim',
    hooks_file: path.join(import.meta.dirname!, "hooks/ddu.lua")
  };

  const uis: RemotePlugin[] = [{
    repo: 'Shougo/ddu-ui-ff',
    hooks_file: path.join(import.meta.dirname!, "hooks/ddu/ui-ff.vim")
  }];

  const sources: RemotePlugin[] = [{
    repo: "Shougo/ddu-source-action"
  }, {
    repo: "4513ECHO/ddu-source-source",
    lua_source: `
vim.fn['ddu#custom#patch_global']('kindOptions', {
  source={
    defaultAction='execute'
  }
})
`
  }, {
      repo: "4513ECHO/ddu-source-colorscheme"
    }, {
      repo: "Shougo/ddu-source-file_old"
    }, {
      repo: "shun/ddu-source-buffer"
    }];

  const filters: RemotePlugin[] = [{
    repo: "Shougo/ddu-filter-matcher_substring",
    lua_source: `
vim.fn['ddu#custom#patch_global']('filterParams', {
  matcher_substring={
    highlightMatched='Search'
  }
})
    `
  }]

  const kinds: RemotePlugin[] = [{
    repo: "Shougo/ddu-kind-file"
  }];

  const otherPlugins: RemotePlugin[] = [{
    repo: "Shougo/ddu-commands.vim",
    depends: 'ddu.vim',
    on_cmd: 'Ddu'
  }]
  const plugins: RemotePlugin[] = [ddu].concat(
    uis,
    sources,
    otherPlugins,
    filters,
    kinds,
  );

  return plugins.map(p => {
    return addName({
      ...p,
    })
  });
}
