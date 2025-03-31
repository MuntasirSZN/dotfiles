return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				term_colors = true,
				compile = {
					enabled = true,
					path = vim.fn.stdpath("cache") .. "/catppuccin",
				},
				dim_inactive = {
					enabled = true,
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
				custom_highlights = {
					SnacksDashboardHeader = { fg = "#F9E2AE" },
					SnacksIndent = { fg = "#30354F" },
				},
				default_integrations = true,
				integrations = {
					which_key = true,
					dadbod_ui = true,
					lsp_trouble = true,
					grug_far = true,
					harpoon = true,
					mason = true,
					neotest = true,
					noice = true,
					diffview = true,
					dap = true,
					dap_ui = true,
					dropbar = {
						enabled = true,
						color_mode = true, -- enable color for kind's texts, not just kind's icons
					},
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = false,
					mini = {
						enabled = false,
						indentscope_color = "",
					},
					dashboard = true,
					neotree = true,
					blink_cmp = true,
					snacks = true,
					fzf = true,
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {},
	},
	{
		"zaldih/themery.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			lazy_require("themery").setup({
				themes = {
					"catppuccin-mocha",
					"catppuccin-macchiato",
					"catppuccin-frappe",
					"catppuccin-latte",
					"tokyonight-moon",
					"tokyonight-storm",
					"tokyonight-night",
					"tokyonight-day",
				},
			})
		end,
	},
}
