return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      fish_lsp = {},
      ty = {},
      tombi = {},
      cssls = {},
      css_variables = {},
      cssmodules_ls = {},
      just = {},
      harper_ls = {
        settings = {
          ["harper-ls"] = {
            userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
          },
        },
      },
    },
  },
}
