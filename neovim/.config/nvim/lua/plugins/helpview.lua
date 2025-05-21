return {
	"OXY2DEV/helpview.nvim",
	ft = { "help" },
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("helpview").setup({
			preview = {
				icon_provider = "devicons",
			},
		})
	end,
}
