local bufferline = require("bufferline")

return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      color_icons = true,             -- Enable/disable color icons,
      show_buffer_icons = true,       -- Enable/disable buffer icons
      show_buffer_close_icons = true, -- Enable/disable close icons on buffers
      show_close_icon = true,
      show_tab_indicators = true,
      diagnostics = "nvim_lsp",
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
      offsets = {
        {
          filetype = "neo-tree",
          text = "  File Explorer",
          highlight = "Directory",
          text_align = "center",
          separator = true,
        },
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
}
