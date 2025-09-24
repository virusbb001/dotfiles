import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { assertObjectMatch } from "jsr:@std/assert";
import { basename } from "jsr:@std/path/basename";
export type RemotePlugin = Partial<Plugin> & Required<Pick<Plugin, 'repo'>>

/**
 * add `name` from repository.
 */
export function addName(plugin: RemotePlugin): Plugin {
  return {
    name: basename(plugin.repo),
    ...plugin
  }
}

Deno.test({
  name: "addName",
  async fn (t) {
    await t.step("add name", () => {
      assertObjectMatch(
        addName({
          repo: "my/awesome-plugin.vim"
        }),
        {
          repo: "my/awesome-plugin.vim",
          name: "awesome-plugin.vim"
        }
      )
    });
    await t.step("do not override name", () => {
      assertObjectMatch(
        addName({
          repo: "my/awesome-plugin.vim",
          name: "name-is-different"
        }),
        {
          repo: "my/awesome-plugin.vim",
          name: "name-is-different"
        }
      )
    });
  }
});
