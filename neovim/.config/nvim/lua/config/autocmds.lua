-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function autocmd(...)
  vim.api.nvim_create_autocmd(...)
end

autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "nofile" then
      return
    end

    vim.schedule(function()
      local wins = vim.fn.win_findbuf(args.buf)
      for _, win in ipairs(wins) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg.relative ~= "" then
          vim.api.nvim_buf_call(args.buf, function()
            pcall(vim.cmd("Markview enable"))
          end)
          break
        end
      end
    end)
  end,
})
