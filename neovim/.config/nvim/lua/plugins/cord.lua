return {
  "vyfor/cord.nvim",
  event = "InsertEnter",
  opts = {
    editor = {
      client = "lazyvim",
    },
    display = {
      theme = "catppuccin",
    },
    extensions = {
      "diagnostics",
      resolver = {
        sources = { true },
      },
      "scoped_timestamps",
    },
  },
}
