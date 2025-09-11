import { type Plugin } from "jsr:@shougo/dpp-vim@~3.1.0/types"
import { addName, type RemotePlugin } from "./util.ts";

export default function getLSPPlugins (): Plugin[] {
  const plugins: RemotePlugin[] = [{
    repo: 'nvim-lua/lsp-status.nvim',
    hook_source: `
function! LspStatus() abort
if luaeval('#vim.lsp.buf_get_clients() > 0')
return luaeval("require('lsp-status').status()")
endif
return ''
endfunction
`
  }, {
      repo: 'jose-elias-alvarez/null-ls.nvim',
      depends: ['plenary.nvim']
    }, {
      repo: 'davidosomething/format-ts-errors.nvim'
    }, {
      repo: 'folke/neodev.nvim'
    }, {
repo: 'neovim/nvim-lspconfig',
      depends: ['lsp-status.nvim', 'null-ls.nvim', 'format-ts-errors.nvim', 'neodev.nvim', 'schemastore.nvim'],
      on_event: ['BufRead', 'BufNewFile'],
      lua_source: `
_G.virus_lsp_settings()
      `
    }];

  return plugins.map(p => {
    return addName({
      ...p,
      lazy: true
    })
  });
}
