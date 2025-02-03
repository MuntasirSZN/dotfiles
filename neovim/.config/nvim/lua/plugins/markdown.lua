return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended

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
	},
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown",
		opts = {},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		keys = {
			{
				"<leader>cmp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
	},
}
