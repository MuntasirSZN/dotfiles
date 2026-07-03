return {
  "Bekaboo/dropbar.nvim",
  lazy = false,
  event = "BufReadPre",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  config = function()
    local opts = {}
    local symbols = {
      BreakStatement = "󰙧 ",
      Call = "󰃷 ",
      CaseStatement = "󱃙 ",
      ContinueStatement = "→ ",
      Declaration = "󰙠 ",
      Delete = "󰩺 ",
      DoStatement = "󰑖 ",
      ForStatement = "󰑖 ",
      H1Marker = "󰉫 ", -- Used by markdown treesitter parser
      H2Marker = "󰉬 ",
      H3Marker = "󰉭 ",
      H4Marker = "󰉮 ",
      H5Marker = "󰉯 ",
      H6Marker = "󰉰 ",
      Identifier = "󰀫 ",
      IfStatement = "󰇉 ",
      List = "󰅪 ",
      Log = "󰦪 ",
      Lsp = " ",
      Macro = "󰁌 ",
      MarkdownH1 = "󰉫 ", -- Used by builtin markdown source
      MarkdownH2 = "󰉬 ",
      MarkdownH3 = "󰉭 ",
      MarkdownH4 = "󰉮 ",
      MarkdownH5 = "󰉯 ",
      MarkdownH6 = "󰉰 ",
      Pair = "󰅪 ",
      Regex = " ",
      Repeat = "󰑖 ",
      Scope = "󰅩 ",
      Specifier = "󰦪 ",
      Statement = "󰅩 ",
      SwitchStatement = "󰺟 ",
      Table = "󰅩 ",
      Terminal = " ",
      Type = " ",
      WhileStatement = "󰑖 ",
    }
    local myicons = require("config.icons").kinds
    opts["icons.kinds.symbols"] = vim.tbl_extend("force", myicons, symbols)
    require("dropbar").setup(opts)

    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
