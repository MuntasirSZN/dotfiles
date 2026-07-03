return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      no_italic = true,
      term_colors = true,
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          ok = { "undercurl" },
        },
      },
      term_palette = true,
      compile = {
        enabled = true,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
      },
      float = {
        solid = true,
      },
      dim_inactive = {
        enabled = true,
      },
      default_integrations = true,
      auto_integrations = true,
      custom_highlights = function(palette)
        local groups = {
          SnacksDashboardHeader = { fg = palette.yellow },
          SnacksIndent = { fg = palette.surface0 },
          SnacksPickerInput = { bg = palette.surface1 },
          SnacksPickerInputBorder = { bg = palette.surface1, fg = palette.surface1 },
          SnacksPickerMatch = { fg = palette.peach },
          SnacksPickerList = { bg = palette.mantle },
          SnacksPickerListBorder = { bg = palette.mantle, fg = palette.mantle },
          SnacksPickerListTitle = { fg = palette.overlay2, bg = "NONE" },

          TimeMachineCurrent = {
            bg = "#313952",
          },
          TimeMachineTimeline = { fg = palette.blue, style = { "bold" } },
          TimeMachineTimelineAlt = { fg = palette.overlay2 },
          TimeMachineKeymap = { fg = palette.teal, style = { "italic" } },
          TimeMachineInfo = { fg = palette.subtext0, style = { "italic" } },
          TimeMachineSeq = { fg = palette.peach, style = { "bold" } },
          TimeMachineTag = { fg = palette.yellow, style = { "bold" } },
        }
        return groups
      end,
      integrations = {
        illuminate = {
          lsp = false,
        },
        dropbar = {
          enabled = true,
          color_mode = true,
        },
        blink_cmp = {
          style = "solid",
        },
        snacks = {
          indent_scope_color = "lavender",
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
