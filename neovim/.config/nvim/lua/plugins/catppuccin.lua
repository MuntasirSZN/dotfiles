return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
					ok = { "undercurl" },
				},
			},
			flavour = "mocha",
			term_colors = true,
			compile = {
				enabled = true,
				path = vim.fn.stdpath("cache") .. "/catppuccin",
			},
			float = {
				solid = true,
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
			auto_integrations = true,
			integrations = {
				illuminate = {
					lsp = false,
				},
				dropbar = {
					color_mode = true,
				},
				blink_cmp = {
					style = "solid",
				},
				snacks = {
					indent_scope_color = "lavender",
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
