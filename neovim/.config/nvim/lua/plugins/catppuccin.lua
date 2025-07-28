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
					SnacksPickerInput = { bg = palette.surface1 },
					SnacksPickerInputBorder = { bg = palette.surface1, fg = palette.surface1 },
					SnacksPickerMatch = { fg = palette.peach },
					SnacksPickerList = { bg = palette.mantle },
					SnacksPickerListBorder = { bg = palette.mantle, fg = palette.mantle },
					SnacksPickerListTitle = { fg = palette.overlay2, bg = "NONE" },
				}
				return groups
			end,
			default_integrations = true,
			integrations = {
				illuminate = {
					enabled = true,
					lsp = false,
				},
				which_key = true,
				dadbod_ui = true,
				lsp_trouble = true,
				octo = true,
				ufo = true,

				grug_far = true,
				mason = true,
				neotest = true,
				neogit = true,
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
				snacks = {
					enabled = true,
					indent_scope_color = "lavender",
					picker_style = "nvchad",
				},
				markview = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
