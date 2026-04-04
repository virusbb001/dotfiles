-- keymaps for multiple plugins

--- @param name string
local function vim_fn(name)
  print(name)
  print(vim.fn.exists("*" .. name))
  if not vim.fn.exists("*" .. name) then
    return false
  end
  local result = vim.fn[name]()
  if result == 0 then
    return false
  end
  return result
end

vim.keymap.set({'i'}, '<C-y>', function()
  if vim_fn("pum#visible") then
    return "<Plug>(pum-confirm)"
  elseif vim_fn("emmet#isExpandable") then
    return "<Plug>(dotfiles-emmet)"
  end
  return "<C-y>"
end, {
  remap = true,
  expr = true
})
