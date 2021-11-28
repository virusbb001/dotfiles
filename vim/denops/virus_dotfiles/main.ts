import { Denops } from "https://deno.land/x/denops_std@v1.0.0/mod.ts"

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async checkAndFetchJsonScheme (): Promise<unknown> {
    }
  }
  // stub
}
