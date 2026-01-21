import { BaseConfig, ConfigArguments } from "@shougo/ddu-vim/config";
import { printError } from "@shougo/ddu-vim/utils";
import { ActionFlags } from "@shougo/ddu-vim/types";
import { type ActionData as KindActionData } from "@shougo/ddu-kind-file";
import { MatcherSubstringParams } from "./types.ts";

const Sources = Object.freeze({
  source: "source"
});

const Kinds = Object.freeze({
  colorscheme: "colorscheme",
  file: "file",
  action: "action",
});

export class Config extends BaseConfig {
  override config (args: ConfigArguments): void {
    const { contextBuilder } = args;
    const matcher_substring: MatcherSubstringParams = {
      highlightMatched: "Search"
    }
    contextBuilder.patchGlobal({
      ui: "ff",
      sourceOptions: {
        _: {
          matchers: ["matcher_substring"]
        },
        [Sources.source]: {
          defaultAction: "execute"
        }
      },
      kindOptions: {
        [Kinds.colorscheme]: {
          defaultAction: "set"
        },
        [Kinds.file]: {
          actions: {
            "term": {
              description: "split and term. Only first item accept",
              callback: async (args) => {
                const denops = args.denops;
                const actionData = args.items[0].action as KindActionData;
                const path = actionData.path;
                if (!path) {
                  await printError(denops, "path not found", actionData);
                  return ActionFlags.Redraw
                }
                const isDirectory = actionData.isDirectory ?? (await Deno.stat(path)).isDirectory;
                if (!isDirectory) {
                  console.log(args.items[0])
                  await printError(denops, "item should be directory");
                  return ActionFlags.Redraw
                }
                await denops.cmd("tab split")
                await denops.cmd(`lcd ${path}`)
                await denops.cmd("terminal")

                return ActionFlags.None;
              }
            }
          },
          defaultAction: "open"
        },
        [Kinds.action]: {
          defaultAction: "do"
        }
      },
      filterParams: {
        matcher_substring
      },
      uiParams: {
        filer: {
          split: "vertical"
        }
      }
    });

    contextBuilder.patchLocal("filer", {
      ui: "filer",
      sources: [{name: "file", params: {}}],
      sourceOptions: {
        _: {
          columns: ["filename"]
        }
      },
      kindOptions: {
        file: {
          defaultAction: "open"
        }
      }
    });
  }
}
