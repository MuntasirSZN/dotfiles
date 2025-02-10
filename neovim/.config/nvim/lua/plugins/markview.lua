return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	event = "VeryLazy",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({
			preview = {
				filetypes = {
					"markdown",
					"norg",
					"rmd",
					"org",
					"mdx",
					"codecompanion",
				},
				ignore_buftypes = {},
			},
			markdown = {
				list_items = {
					shift_width = function(buffer, item)
						--- Reduces the `indent` by 1 level.
						---
						---         indent                      1
						--- ------------------------- = 1 ÷ --------- = new_indent
						--- indent * (1 / new_indent)       new_indent
						---
						local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

						return item.indent * (1 / (parent_indnet * 2))
					end,
					marker_minus = {
						add_padding = function(_, item)
							return item.indent > 1
						end,
					},
				},
			},
			icon_provider = "devicons",
		})

		require("markview.extras.editor").setup()
		require("markview.extras.checkboxes").setup()
		require("markview.extras.headings").setup()
	end,
}
