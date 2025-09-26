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
  }, {
    repo: 'Shougo/ddu-ui-filer',
    hooks_file: path.join(import.meta.dirname!, "hooks/ddu/ui-filer.vim")
  }];

  const sources: RemotePlugin[] = [{
    repo: "Shougo/ddu-source-action"
  }, {
    repo: "4513ECHO/ddu-source-source",
  }, {
      repo: "4513ECHO/ddu-source-colorscheme"
    }, {
      repo: "Shougo/ddu-source-file_old"
    }, {
      repo: "shun/ddu-source-buffer"
    }, {
      repo: "Shougo/ddu-source-file_rec"
    }, {
      repo: "Shougo/ddu-source-file"
    }, {
      repo: "4513ECHO/ddu-source-emoji"
    }, {
      repo: "shutils/ddu-source-obsidian"
    }];

  const filters: RemotePlugin[] = [{
    repo: "Shougo/ddu-filter-matcher_substring",
  }, {
    repo: "Shougo/ddu-filter-converter_display_word"
  }]

  const kinds: RemotePlugin[] = [{
    repo: "Shougo/ddu-kind-file"
  }, {
      repo: "Shougo/ddu-kind-word"
    }];

  const columns: RemotePlugin[] = [{
    repo: "Shougo/ddu-column-filename"
  }]

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
    columns,
  );

  return plugins.map(p => {
    return addName({
      ...p,
    })
  });
}
