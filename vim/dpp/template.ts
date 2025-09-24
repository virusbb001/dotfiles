import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";
import * as path from "jsr:@std/path";

// TODO: rename
export default function getSomePlugins(): Plugin[] {
  const plugins: RemotePlugin[] = [{
    repo: 'user/plugin',
    hooks_file: path.join(import.meta.dirname!, "hooks/plugin.lua")
  }];

  return plugins.map(addName);
}
