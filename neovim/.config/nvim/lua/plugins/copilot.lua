return {
  "zbirenbaum/copilot.lua",
  event = "BufReadPost",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<Tab>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      filetypes = {
        ["*"] = true,
      },
      workspace_folders = {
        "/home/muntasir/Projects",
      },
      should_attach = function(_, bufname)
        if string.match(bufname, "env") then
          return false
        end

        return true
      end,
      server = {
        type = "binary",
        custom_server_filepath = vim.fn.stdpath("data") .. "/mason/bin/copilot-language-server",
      },
    })
  end,
}
