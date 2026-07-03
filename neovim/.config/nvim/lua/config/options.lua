-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.filetype.add({
  pattern = {
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})

vim.loader.enable()
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

local opt = vim.opt

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "󰿟",
  eob = " ",
}
opt.grepprg = "rg --vimgrep"
opt.relativenumber = false
opt.smoothscroll = true

vim.diagnostic.config({
  underline = true,
  update_in_insert = true,
  document_highlight = {
    enabled = true,
  },
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("config.icons").diagnostics.Error,
      [vim.diagnostic.severity.WARN] = require("config.icons").diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = require("config.icons").diagnostics.Info,
      [vim.diagnostic.severity.HINT] = require("config.icons").diagnostics.Hint,
    },
  },
  severity_sort = true,
})
