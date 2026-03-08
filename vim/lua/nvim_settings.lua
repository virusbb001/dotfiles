local autogroup = "DotfilesNvimSettings"

local function config()
  vim.diagnostic.config({
    virtual_text = {
      source = true
    }
  })

  vim.api.nvim_create_augroup(autogroup, { clear = true })

  -- :help terminal-osc7
  vim.api.nvim_create_autocmd({ "TermRequest" }, {
    group = autogroup,
    desc = 'Haldles OSC 7 dir change requests',
    callback = function(ev)
      if string.sub(ev.data.sequence, 1, 4) == '\x1b]7;' then
        local dir = string.gsub(ev.data.sequence, '\x1b]7;file://[^/]*', '')
        vim.notify(dir)
        if vim.fn.isdirectory(dir) == 0 then
          vim.notify('invalid dir: '..dir)
          return
        end
        vim.api.nvim_buf_set_var(ev.buf, 'osc7_dir', dir)
        vim.cmd.lcd(dir)
        --[[
        if vim.o.autochdir and vim.api.nvim_get_current_buf() == ev.buf then
        end
        ]]
      end
    end
  })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'DirChanged' }, {
    group = autogroup,
    callback = function()
      if vim.b.osc7_dir and vim.fn.isdirectory(vim.b.osc7_dir) == 1 then
        vim.cmd.lcd(vim.b.osc7_dir)
      end
    end
  })
end

config()
