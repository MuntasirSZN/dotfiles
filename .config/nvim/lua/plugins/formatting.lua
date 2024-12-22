return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim"
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.shfmt,
        require("none-ls.diagnostics.eslint_d"), -- requires none-ls-extras.nvim
        null_ls.builtins.diagnostics.gitsigns,
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.gofumpt,
      },
    })
  end
}
