return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("octo").setup()
		vim.treesitter.language.register("markdown", "octo")
	end,
}
