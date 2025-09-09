import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

export default function getLazyPlugins(): Plugin[] {
  const skkeletonPlugins: RemotePlugin[] = [{
    repo: "skk-dev/dict",
    name: "skk-dict",
  }, {
    repo: "vim-skk/skkeleton",
    on_map: {"ict": "<Plug>(skkeleton-"},
    depends: ["skk-dict"],
    hooks_file: path.join(import.meta.dirname!, "hooks/skkeleton.vim")
  }, {
    repo: "delphinus/skkeleton_indicator.nvim",
    on_source: "skkeleton",
    hooks_file: (path.join(import.meta.dirname!, "hooks/skkeleton_indicator.lua"))
  }];

  const otherPlugins: RemotePlugin[] = [{
    repo: 'tyru/open-browser.vim'
  }, {
      repo: 'previm/previm',
      on_cmd: 'PrevimOpen',
      depends: 'open-browser.vim'
  }]

  const lazyPlugins = ([] as RemotePlugin[])
  .concat(skkeletonPlugins, otherPlugins)
  .map((p): RemotePlugin => ({
    ...p,
    lazy: true
  }));

  return lazyPlugins.map(addName);
}
