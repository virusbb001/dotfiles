
// https://github.com/Shougo/ddu-filter-matcher_substring/blob/a1fc22fd0b64be2d8fb5469e1ad0645e0b3988b3/denops/%40ddu-filters/matcher_substring/main.ts#L6-L9
interface MatcherSubstringParamsFull {
  highlightMatched: string;
  limit: number;
}

export type MatcherSubstringParams = Partial<MatcherSubstringParamsFull>;
