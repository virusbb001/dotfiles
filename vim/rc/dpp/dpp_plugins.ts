import * as path from "jsr:@std/path";
import { basename } from "jsr:@std/path/basename";
import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"

export default async function getDppPlugins(): Promise<Plugin[]> {
  const plugin_map = (await import("./dpp_plugins.json", {
    with: {
      type: "json"
    }
  })).default;

  const extraSettings: Record<string, Partial<Plugin>> = {
    "dpp.vim": {
      hooks_file: path.join(import.meta.dirname!, "hooks/dpp.vim")
    }
  };

  const plugins = plugin_map.minimal.concat(plugin_map.install).map(plugin_repo => {
    const name = basename(plugin_repo);
    return {
      repo: plugin_repo,
      name,
      ...(extraSettings[name] ?? {})
    };
  });

  return plugins;
};

if (import.meta.main) {
  // check behavior
  console.log(await getDppPlugins());
}
