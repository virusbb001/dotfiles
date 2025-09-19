import { BaseConfig, ConfigArguments } from "@shougo/ddu-vim/config";
import { MatcherSubstringParams } from "./types.ts";

const Sources = Object.freeze({
  source: "source"
});

const Kinds = Object.freeze({
  colorscheme: "colorscheme"
});

export class Config extends BaseConfig {
  override config (args: ConfigArguments): void {
    const { contextBuilder } = args;
    const matcher_substring: MatcherSubstringParams = {
      highlightMatched: "Search"
    }
    contextBuilder.patchGlobal({
      ui: "ff",
      sourceOptions: {
        [Sources.source]: {
          defaultAction: "execute"
        }
      },
      kindOptions: {
        [Kinds.colorscheme]: {
          defaultAction: "set"
        }
      },
      filterParams: {
        matcher_substring
      }
    });

    contextBuilder.patchLocal("filer", {
      ui: "filer",
      sources: [{name: "file", params: {}}],
      sourceOptions: {
        _: {
          columns: ["filename"]
        }
      },
      kindOptions: {
        file: {
          defaultAction: "open"
        }
      }
    });
  }
}
