return {
  "HakonHarnes/img-clip.nvim",
  event = "InsertEnter",
  opts = {
    default = {
      dir_path = "Pictures/Screenshots",
      use_absolute_path = true,
      prompt_for_file_name = false,
      file_name = "screenshot-%Y-%m-%d_%H.%M-%S",
    },
    filetypes = {
      markdown = {
        url_encode_path = true, ---@type boolean
        template = "![Image]($FILE_PATH)",
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.add({
      {
        "<leader>V",
        "<cmd>PasteImage<cr>",
        desc = "Paste image from system clipboard",
        icon = {
          name = "png",
          cat = "extension",
        },
      },
    })
    require("img-clip").setup(opts)
  end,
}
