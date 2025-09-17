import { BaseConfig, ConfigArguments } from "@shougo/ddu-vim/config";
import { MatcherSubstringParams } from "./types.ts";

const Sources = Object.freeze({
  source: "source"
})

export class Config extends BaseConfig {
  override config (args: ConfigArguments): void {
    const { contextBuilder } = args;
    const matcher_substring: MatcherSubstringParams = {
      highlightMatched: "Search"
    }
    contextBuilder.setGlobal({
      ui: "ff",
      sourceOptions: {
        [Sources.source]: {
          defaultAction: "execute"
        }
      },
      filterParams: {
        matcher_substring
      }
    });
  }
}
