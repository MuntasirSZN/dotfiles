return {
  { "folke/neodev.nvim" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },
  { import = "lazyvim.plugins.extras.lang.json" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "css",
        "c",
        "cpp",
        "c_sharp",
        "ruby",
        "rust",
        "php",
        "julia",
        "go",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({})
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
            theme = "catppuccin",
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "phpactor",
          "cssls",
          "clangd",
          "cmake",
          "rust_analyzer",
          "julials",
          "dockerls",
          "docker_compose_language_service",
          "eslint",
          "emmet_language_server",
          "lua_ls",
          "html",
          "tsserver",
          "autotools_ls",
          "markdown_oxide",
          "pylsp",
          "tailwindcss",
          "yamlls",
          "jsonls",
          "biome",
        },
      })
    end,
  },
  {
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("lspconfig").clangd.setup({})
        require("lspconfig").cmake.setup({})
        require("lspconfig").emmet_language_server.setup({})
        require("lspconfig").dockerls.setup({})
        require("lspconfig").eslint.setup({})
        require("lspconfig").html.setup({})
        require("lspconfig").jsonls.setup({})
        require("lspconfig").lua_ls.setup({})
        require("lspconfig").tsserver.setup({})
        require("lspconfig").yamlls.setup({})
        require("lspconfig").biome.setup({})
        require("lspconfig").tailwindcss.setup({})
        require("lspconfig").docker_compose_language_service.setup({})
        require("lspconfig").cssls.setup({})
        require("lspconfig").bashls.setup({})
        require("lspconfig").phpactor.setup({})
        require("lspconfig").rust_analyzer.setup({})
        require("lspconfig").julials.setup({})
        require("lspconfig").markdown_oxide.setup({})
        require("lspconfig").pylsp.setup({})
        require("lspconfig").autotools_ls.setup({})
      end,
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        setup = {
          rust_analyzer = function()
            return true
          end,
        },
      },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local logo = [[
                                                                               
                                                                               
                 ████ ██████           █████      ██                     
                ███████████             █████                             
                █████████ ███████████████████ ███   ███████████   
               █████████  ███    █████████████ █████ ██████████████   
              █████████ ██████████ █████████ █████ █████ ████ █████   
            ███████████ ███    ███ █████████ █████ █████ ████ █████  
           ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        
        ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
          { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 46 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
  {
    "catppuccin/nvim",
    colorscheme = "catppuccin",
    config = function()
      require("catppuccin").setup({
        transparent_background = false,
        term_colors = false,
        compile = {
          enabled = false,
          path = vim.fn.stdpath("cache") .. "/catppuccin",
        },
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        styles = {
          comments = { "bold" },
          conditionals = { "bold" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        highlight_overrides = {},
      })
    end,
  },
}
