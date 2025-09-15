--[[
`:help root_dir` or `:help lsp-core`
--]]

local util = require('lspconfig/util')

--[[
Detect that file and buffer is deno project.
If shebang is deno, it will return dirname of file.
If it isn't, find deno.json and deno.jsonc and return.
--]]
local function detect_deno_root_dir (bufnr, on_dir)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local firstline = vim.fn.getbufline(bufnr, 1)[1] or ""
  -- detect from shebang
  local is_shebang = string.sub(firstline, 1, 2) == "#!"
  if is_shebang and string.match(firstline, "deno") then
    on_dir(vim.fs.dirname(filename))
    return
  end
  local root = util.root_pattern('deno.json', 'deno.jsonc')(filename)
  if root then
    on_dir(root)
    return
  end
end

--[[
If file is deno project, return nil.
Otherwise, find package.json and return.
--]]
local function detect_node_root_dir (bufnr, on_dir)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local is_deno = detect_deno_root_dir(bufnr)
  if is_deno then
    return
  end
  local root = util.root_pattern('package.json')(filename)
  if root then
    on_dir(root)
  end
end

return {
  detect_deno_root_dir = detect_deno_root_dir,
  detect_node_root_dir = detect_node_root_dir,
}
