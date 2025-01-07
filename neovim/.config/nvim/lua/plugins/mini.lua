return {
  {
    "echasnovski/mini.ai",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          local filetype = vim.bo.filetype
          local disabled_filetypes = { "snacks_dashboard" }
          if not vim.tbl_contains(disabled_filetypes, filetype) then
            require("mini.indentscope").setup()
          end
        end,
      })
    end,
  },
}
