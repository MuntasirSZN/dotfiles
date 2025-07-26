return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			term_colors = true,
			compile = {
				enabled = true,
				path = vim.fn.stdpath("cache") .. "/catppuccin",
			},
			dim_inactive = {
				enabled = true,
			},
			no_italic = true,
			custom_highlights = function(palette)
				local groups = {
					SnacksDashboardHeader = { fg = palette.yellow },
					SnacksIndent = { fg = palette.surface0 },
				}
				return groups
			end,
			default_integrations = true,
			integrations = {
				which_key = true,
				dadbod_ui = true,
				lsp_trouble = true,
				grug_far = true,
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
				gitsigns = true,
				treesitter = true,
				mini = {
					enabled = true,
				},
				neotree = true,
				blink_cmp = true,
				snacks = true,
				markview = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
