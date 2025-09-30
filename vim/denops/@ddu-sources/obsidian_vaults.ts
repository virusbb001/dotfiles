import { ensure, is } from "jsr:@core/unknownutil@4.3.0";
import { BaseSource, GatherArguments } from "jsr:@shougo/ddu-vim/source";
import { ActionFlags, Actions, BaseParams, Item, DduOptions } from "jsr:@shougo/ddu-vim/types";
import xdg from "jsr:@404wolf/xdg-portable";
import { join } from "jsr:@std/path";
import { printError } from "jsr:@shougo/ddu-vim/utils";
import type { ActionData } from "jsr:@shougo/ddu-kind-file";
import { Denops } from "https://jsr.io/@denops/core/8.0.0/type.ts";

interface ObsidianVault {
  path: string,
  ts: string,
  open: boolean,
}

interface ObsidianVaultData {
  vaults: Record<string, ObsidianVault>
}

/**
 * referenced from https://github.com/Yakitrak/obsidian-cli/blob/5d259771173c5f24f66b95bb0a6516f4e4a4f908/pkg/config/obsidian_path.go#L8
 * https://pkg.go.dev/os#UserConfigDir
 */
async function getUserConfigDir (denops: Denops): Promise<string> {
  switch (Deno.build.os) {
    case "windows":
      // https://learn.microsoft.com/ja-jp/windows/deployment/usmt/usmt-recognized-environment-variables
      return Deno.env.get("APPDATA") ?? ensure(await denops.eval(`expand("~/AppData/Roaming")`), is.String);
    case "darwin":
      return join(Deno.env.get("HOME")!, "Library", "Application Support")
    default:
      return xdg.config();
  }
}

export class Source extends BaseSource<BaseParams> {
  override kind = "file";

  async getObsidianVaults (denops: Denops): Promise<string[]> {
    const config_dir = await getUserConfigDir(denops)
    const obsidian_json = join(config_dir, "obsidian", "obsidian.json");
    let obsidian;
    try {
      obsidian = JSON.parse(await Deno.readTextFile(obsidian_json)) as ObsidianVaultData;
    } catch (e) {
      console.error(e);
      // todo: handle error
      return [];
    }
    const vaults = Object.values(obsidian?.vaults ?? {}).map(vault => vault.path).filter(p => p);
    return vaults;
  }

  override actions: Actions<BaseParams> = {
    obsidian_note: {
      description: "Open obsidian_note source",
      callback: async (args) => {
        const denops = args.denops;
        const path = (args.items[0].action as ActionData).path;
        if (!path) {
          console.log(args.items);
          printError(denops, "path is undefined");
          return ActionFlags.Persist;
        }

        const opts: Partial<DduOptions> = {
          push: true,
          sources: [{
            name: "obsidian_note",
            params: {
              vaults: [{
                path,
                name: path
              }]
            },
            options: {
              matchers: [
                "converter_obsidian_rel_path",
                "converter_obsidian_title",
                "converter_display_word",
                "matcher_substring",
              ],
              converters: [
                "converter_obsidian_backlink"
              ]
            }
          }]
        }

        await denops.call("ddu#start", opts);
        return ActionFlags.None
      }
    }
  };

  override gather({ denops }: GatherArguments<BaseParams>): ReadableStream<Item<ActionData>[]> {

    return new ReadableStream({
      start: async (controller) => {
        const vaults = await this.getObsidianVaults(denops);
        const items = vaults.map((vault): Item<ActionData> => ({
          word: vault,
          action: {
            path: vault,
            isDirectory: true
          }
          // vault is directory but not expected to tread as directory, so isTree should be false
        }));
        controller.enqueue(items);
        controller.close();
      }
    });
  }

  override params(): BaseParams {
    return {};
  }
}
