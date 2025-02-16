return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  lazy = true,
  keys = {
    { "<leader>ce", "<cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" },
  },
  opts = {
    filetypes = {},
  },
}
