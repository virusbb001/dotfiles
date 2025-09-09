import { Plugin } from "jsr:@shougo/dpp-vim@3.1/types";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn
} from "jsr:@shougo/dpp-vim@~3.1.0/config";
import { LazyMakeStateResult } from "jsr:@shougo/dpp-ext-lazy@~2.0.1";
import getDppPlugins from "./dpp_plugins.ts";
import getLazyPlugins from "./lazy.ts";
import * as path from "jsr:@std/path";
import { RemotePlugin, addName } from "./util.ts";

function f(p: RemotePlugin[]): Plugin[] {
  return p.map(addName)
}

// TODO: search "may be lazy" and enable lazy

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder } = args;
    contextBuilder.setGlobal({
      protocols: ["git"]
    });
    const dppPlugins = await getDppPlugins();

    const nonLazyPlugins: Plugin[] = f([{
      repo: 'sjl/gundo.vim',
      if: 'has("python") || has("python3")',
      hook_add: `
if has("python3")
let g:gundo_prefer_python3 = 1
endif`
    }, {
        repo: 'editorconfig/editorconfig-vim'
    }, {
        repo: 'vim-jp/vimdoc-ja'
    }, {
        repo: "tmux-plugins/vim-tmux",
    }, {
        repo: "kana/vim-gf-user"
    }, {
        // may be lazy
        repo: "idanarye/vim-smile"
    }, {
        // may be lazy
        repo: "junegunn/vim-emoji"
    }, {
        // may be lazy
        repo: "b0o/schemastore.nvim"
    }, {
        // may be lazy
        repo: "tpope/vim-fugitive"
    }, {
        repo: "Shougo/context_filetype.vim"
    }, {
        // may be lazy
        repo: "thinca/vim-prettyprint"
    }, {
        // may be lazy
        repo: "thinca/vim-quickrun"
    }]);

    const colorschemes = f([
      'sjl/badwolf',
      'cocopon/iceberg.vim',
      'morhetz/gruvbox',
      "folke/tokyonight.nvim"
    ].map(repo => ({repo})));


    const lazyPlugins = getLazyPlugins();

    // may be lazy
    const dadbodPlugins: Plugin[] = f([{
      repo: "tpope/vim-dadbod"
    }, {
      repo: "kristijanhusak/vim-dadbod-ui"
    }, {
      repo: "pbogut/vim-dadbod-ssh"
    }])

    const allPlugins = ([] as Plugin[]).concat(
      dppPlugins,
      nonLazyPlugins,
      dadbodPlugins,
      colorschemes,
      lazyPlugins);

    const [context, options] = await contextBuilder.get(args.denops);

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: allPlugins
      }
    ) as LazyMakeStateResult | undefined;

    const plugins = lazyResult?.plugins ?? [];
    const stateLines = lazyResult?.stateLines ?? [];

    // check files.
    const checkFiles = [
      import.meta.filename,
      path.join(import.meta.dirname!, "lazy.ts")
    ].filter(v => typeof v === "string");

    return {
      plugins: plugins,
      checkFiles,
      stateLines
    }
  }
}
