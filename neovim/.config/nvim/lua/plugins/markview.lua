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
				markdown = {
					list_items = {
						indent_size = 0,
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
