import { Plugin } from "jsr:@shougo/dpp-vim@3.1/types";
import {
  BaseConfig,
  ConfigArguments,
  ConfigReturn
} from "jsr:@shougo/dpp-vim@~3.1.0/config";
import getDppPlugins from "./dpp_plugins.ts";

// type RemotePlugin = Partial<Plugin> & Required<Pick<Plugin, 'repo'>>

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder } = args;
    contextBuilder.setGlobal({
      protocols: ["git"]
    });

    const dppPlugins = await getDppPlugins();

    const lazyPlugins: Plugin[] = ([{
      repo: "tweekmonster/helpful.vim",
      name: "helpful.vim",
      on_cmd: "HelpfulVersion"
    }] satisfies Plugin[]).map((p: Plugin): Plugin => ({
      ...p,
      lazy: true
    }));

    const allPlugins = ([] as Plugin[]).concat(dppPlugins, lazyPlugins);

    const [context, options] = await contextBuilder.get(args.denops);

    // READMEにはこのように定義するよう書かれているが、 @dpp-exts/lazy/main.ts では exportされているのでそちらを使用したほうが良いかも
    interface LazyMakeStateResult {
      plugins: Plugin[];
      stateLines: string[];
    }

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

    return {
      plugins: plugins,
      checkFiles: [
        import.meta.filename
      ].filter(v => typeof v === "string"),
      stateLines
    }
  }
}
