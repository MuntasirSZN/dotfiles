-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<leader>ls", ":LiveServerStart<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>le", ":LiveServerStop<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>lt", ":LiveServerToggle<CR>", { noremap = true, silent = true })
