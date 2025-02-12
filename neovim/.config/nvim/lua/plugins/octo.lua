return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("octo").setup()
  end,
}
