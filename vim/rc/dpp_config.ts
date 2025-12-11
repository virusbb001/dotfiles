import { Plugin } from "@shougo/dpp-vim/types";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn
} from "@shougo/dpp-vim/config";
import { LazyMakeStateResult } from "@shougo/dpp-ext-lazy";
import { globpath } from "@denops/std/function";

import { RemotePlugin, addName } from "./dpp/util.ts";

import getDppPlugins from "./dpp/dpp_plugins.ts";
import getLazyPlugins from "./dpp/lazy.ts";
import getLSPPlugins from "./dpp/lsp_plugins.ts";
import getTSPlugins from "./dpp/ts_plugins.ts";
import getNvimPlugins from "./dpp/nvim_plugins.ts";
import getDduPlugins from "./dpp/ddu_plugins.ts";
import getFiletypePlugins from "./dpp/filetype_plugins.ts";

function f(p: RemotePlugin[]): Plugin[] {
  return p.map(addName)
}

// TODO: search "may be lazy" and enable lazy

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder, denops } = args;
    const githubAPIToken = await denops.eval(`get(g:, 'github_api_token', "")`);
    contextBuilder.setGlobal({
      protocols: ["git"],
      extParams: {
        installer: {
          githubAPIToken
        }
      }
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

    const lspPlugins = getLSPPlugins();

    const nvimPlugins = args.denops.meta.host === "nvim" ? getNvimPlugins() : [];

    const allPlugins = ([] as Plugin[]).concat(
      dppPlugins,
      nonLazyPlugins,
      dadbodPlugins,
      colorschemes,
      lazyPlugins,
      lspPlugins,
      getTSPlugins(),
      nvimPlugins,
      getDduPlugins(),
      getFiletypePlugins(),
    );

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

    const dirname = import.meta.dirname!;
    // hooks
    const hooks = (await denops.eval(`globpath("${dirname}", "hooks/**/*", v:true, v:true)->filter('!isdirectory(v:val)')`)) as string[];

    // check files.
    const checkFiles = ([] as string[]).concat(
      await globpath(denops, dirname, "**/*.ts", true, true),
      hooks
    ).filter(v => typeof v === "string");

    return {
      plugins: plugins,
      checkFiles,
      stateLines
    }
  }
}
