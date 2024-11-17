require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

vim.g.base46_cache = vim.fn.stdpath('data') .. '/base46_cache/'

-- At First Time, Uncomment this line, Then Open Neovim, Then Comment this line again Or Delete it.
-- require('base46').load_all_highlights()

dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "devicons")
dofile(vim.g.base46_cache .. "telescope")
dofile(vim.g.base46_cache .. "colors")
dofile(vim.g.base46_cache .. "git")
dofile(vim.g.base46_cache .. "mason")
dofile(vim.g.base46_cache .. "lsp")
dofile(vim.g.base46_cache .. "nvcheatsheet")
dofile(vim.g.base46_cache .. "term")
dofile(vim.g.base46_cache .. "whichkey")
