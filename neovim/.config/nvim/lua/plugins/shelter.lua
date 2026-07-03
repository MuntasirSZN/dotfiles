return {
  "ph1losof/shelter.nvim",
  lazy = false,
  keys = {
    { "<leader>st", "<cmd>Shelter toggle<cr>", desc = "Toggle masking" },
  },
  opts = {
    modules = {
      ecolog = {
        cmp = true, -- Mask in completion
        peek = false, -- Show real value on hover
        picker = false, -- Show real value in picker
      },
      files = true,
      snacks_previewer = true,
    },
  },
}
