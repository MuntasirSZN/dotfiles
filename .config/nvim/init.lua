require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

vim.g.base46_cache = vim.fn.stdpath('data') .. '/base46_cache/'

dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "devicons")
dofile(vim.g.base46_cache .. "telescope")
