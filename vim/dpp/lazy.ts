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

  const lazyPlugins = ([] as RemotePlugin[])
  .concat(skkeletonPlugins)
  .map((p): RemotePlugin => ({
    ...p,
    lazy: true
  }));

  return lazyPlugins.map(addName);
}
