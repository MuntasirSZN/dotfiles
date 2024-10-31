return {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      -- Define the function globally to ensure it is accessible for keymaps
      _G.find_nvim_files = function()
        local builtin = require('telescope.builtin')
        builtin.find_files({
          prompt_title = "< NVIM CONFIG >",
          cwd = "~/.config/nvim", -- Set the directory to search in
          hidden = true           -- Show hidden files, useful in config directories
        })
      end

      -- Telescope setup
      require("telescope").setup({
        defaults = {
          -- Default settings go here
          prompt_prefix = "   ",
          selection_caret = "➤ ",
          path_display = { "smart" },
        },
        pickers = {
          find_files = {
            hidden = true,
            -- theme = "dropdown",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Keymap setup
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua find_nvim_files()<CR>", { noremap = true, silent = true })

      -- Load extensions
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("noice")
    end,
  },
}
