return {
  "s1n7ax/nvim-window-picker",
  name = "window-picker",
  event = "VeryLazy",
  version = "*",
  config = function()
    require("window-picker").setup({
      hint = "floating-big-letter",
      picker_config = {
        handle_mouse_click = true,
      },
    })
  end,
}
