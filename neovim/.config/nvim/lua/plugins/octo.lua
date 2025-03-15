return {
	"pwntester/octo.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
	},
	config = function()
		require("octo").setup({
			picker = "snacks",
		})
		vim.treesitter.language.register("markdown", "octo")
	end,
}
