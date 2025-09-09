import { basename } from "jsr:@std/path/basename";
import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"

export default async function getDppPlugins(): Promise<Plugin[]> {
  const plugin_map = (await import("./dpp_plugins.json", {
    with: {
      type: "json"
    }
  })).default;

  const plugins = plugin_map.minimal.concat(plugin_map.install).map(plugin_repo => {
    return {
      repo: plugin_repo,
      name: basename(plugin_repo)
    };
  });

  return plugins;
};

if (import.meta.main) {
  // check behavior
  console.log(await getDppPlugins());
}
