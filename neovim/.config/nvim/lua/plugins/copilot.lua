return {
  "zbirenbaum/copilot.lua",
  event = "BufEnter",
  config = function()
    require("copilot").setup({
      panel = { enabled = false },
      suggestion = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function(bufnr)
        -- From TJDevries
        -- https://github.com/tjdevries/lazy-require.nvim
        local function lazy_require(require_path)
          return setmetatable({}, {
            __index = function(_, key)
              return require(require_path)[key]
            end,

            __newindex = function(_, key, value)
              require(require_path)[key] = value
            end,
          })
        end

        local c = lazy_require("copilot.client")

        local is_current_buffer_attached = function()
          return c.buf_is_attached(bufnr)
        end

        if is_current_buffer_attached() then
          vim.cmd([[ Copilot! attach ]])
        end
      end,
    })
  end,
}
