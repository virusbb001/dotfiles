import { BaseConfig, ConfigArguments } from "@shougo/ddc-vim/config";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "native",
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
          forceCompletionPattern: String.raw`\.\w*|:\w*|->\w*`
        }
      },
      sourceParams: {
        around: {
          maxSize: 500
        },
        lsp: {
          enableResolveItem: true,
          enableAdditionalTextEdit: true
        }
      }
    });
  };
}
