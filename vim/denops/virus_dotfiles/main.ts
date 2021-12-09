import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts"
import { execute } from "https://deno.land/x/denops_std@v1.0.0/helper/mod.ts"
import { ensureString } from "https://deno.land/x/unknownutil@v0.1.1/mod.ts";
import { getJsonSchema } from "./fetch_json_schema.ts"

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async checkAndFetchJsonScheme (dirname: unknown): Promise<unknown> {
      ensureString(dirname);
      return await getJsonSchema(dirname)
    }
  }

  await execute(
    denops,
    `command! VirusUpdateJsonScheme call denops#request('${denops.name}', 'checkAndFetchJsonScheme', [stdpath('cache')])`
  )
}
