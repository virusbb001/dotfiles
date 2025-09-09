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

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const { contextBuilder } = args;
    contextBuilder.setGlobal({
      protocols: ["git"]
    });

    const dppPlugins = await getDppPlugins();

    /*
    const lazyPlugins: Plugin[] = ([{
      repo: "tweekmonster/helpful.vim",
      name: "helpful.vim",
      on_cmd: "HelpfulVersion"
    }] satisfies Plugin[]).map((p: Plugin): Plugin => ({
      ...p,
      lazy: true
    }));
    */

    const lazyPlugins = getLazyPlugins();

    const allPlugins = ([] as Plugin[]).concat(dppPlugins, lazyPlugins);

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
