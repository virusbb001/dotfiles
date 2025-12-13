import { type Plugin } from "@shougo/dpp-vim/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "@std/path";

// TODO: rename
export default function getSomePlugins(): Plugin[] {
  const core: RemotePlugin[] = [{
    repo: 'Shougo/ddc.vim',
    depends: ['denops.vim'],
    on_event: ['InsertEnter', 'CmdlineEnter'],
    lazy: true,
    hooks_file: path.join(import.meta.dirname!, "hooks/ddc.vim")
  }];

  const uis: RemotePlugin[] = [{
    repo: 'Shougo/ddc-ui-native'
  }]

  const sources: RemotePlugin[] = [{
    repo: 'Shougo/ddc-source-lsp',
  }, {
    repo: 'Shougo/ddc-source-around'
  }];

  const matchers: RemotePlugin[] = [{
    repo: 'Shougo/ddc-matcher_head',
  }];

  const sorters: RemotePlugin[] = [{
    repo: 'Shougo/ddc-sorter_rank'
  }];

  const ddcPlugins = uis.concat(sources).concat(matchers).concat(sorters).map(v => Object.assign(v, {
    on_source: ["ddc.vim"]
  } satisfies Partial<Plugin>));

  return core.concat(ddcPlugins).map(addName);
}
