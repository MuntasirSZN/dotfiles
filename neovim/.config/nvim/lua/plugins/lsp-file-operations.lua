return {
  {
    "Crysthamus/nvim-file-operations",
    dependencies = {
      "nvim-neo-tree/neo-tree.nvim",
    },
    lazy = false,
    config = function()
      require("nvim-file-operations").setup()
    end,
  },
}
