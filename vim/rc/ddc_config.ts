import { BaseConfig, ConfigArguments } from "@shougo/ddc-vim/config";
import { Params as LspSourceParams } from "jsr:@shougo/ddc-source-lsp";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments): Promise<void> {
    const denops = args.denops;
    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: ['around', 'lsp'],
      sourceOptions: {
        _: {
          matchers: ['matcher_head'],
          sorters: ['sorter_rank'],
        },
        around: {
          mark: "A"
        },
        lsp: {
          isVolatile: true,
          mark: "lsp",
          forceCompletionPattern: String.raw`\.\w*|:\w*|->\w*`,
          dup: "force"
        }
      },
      sourceParams: {
        around: {
          maxSize: 500
        },
        lsp: {
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
          snippetEngine: async (body) => {
            await denops.call("vsnip#anonymous", body)
          }
        } satisfies Partial<LspSourceParams>
      }
    });
  };
}
