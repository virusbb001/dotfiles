import { BaseSource, GatherArguments } from "jsr:@shougo/ddu-vim/source";
import { ActionFlags, Actions, BaseParams, Item, DduOptions } from "jsr:@shougo/ddu-vim/types";
import xdg from "jsr:@404wolf/xdg-portable";
import { join } from "jsr:@std/path";
import { printError } from "jsr:@shougo/ddu-vim/utils";
import type { ActionData } from "jsr:@shougo/ddu-kind-file";

interface ObsidianVault {
  path: string,
  ts: string,
  open: boolean,
}

interface ObsidianVaultData {
  vaults: Record<string, ObsidianVault>
}

export class Source extends BaseSource<BaseParams> {
  override kind = "file";

  async getObsidianVaults (): Promise<string[]> {
    // referenced from https://github.com/Yakitrak/obsidian-cli/blob/5d259771173c5f24f66b95bb0a6516f4e4a4f908/pkg/config/obsidian_path.go#L8
    const xdg_config = xdg.config();
    const obsidian_json = join(xdg_config, "obsidian", "obsidian.json");
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

  override gather({ }: GatherArguments<BaseParams>): ReadableStream<Item<ActionData>[]> {

    return new ReadableStream({
      start: async (controller) => {
        const vaults = await this.getObsidianVaults();
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
