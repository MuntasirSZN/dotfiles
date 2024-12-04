return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "NvChad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  -- if u want nvchad's ui plugin :)
  {
    "NvChad/ui",
    config = function()
      require("nvchad")
    end,
  },

  -- dependency for ui
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = function()
      return { override = require("nvchad.icons.devicons") }
    end,
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },
  -- {
  --   "FredrikAleksander/volt-nvim",
  -- },
  {
    "nvzone/volt",
    lazy = true,
  },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvzone/menu",
    config = function()
      vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
        vim.cmd.exec('"normal! \\<RightMouse>"')

        local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
        require("menu").open(options, { mouse = true })
      end, {})
    end,
  },
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  { "nvzone/typr", lazy= true, opts = {} },
  { "nvzone/showkeys", cmd = "ShowkeysToggle" }
}
