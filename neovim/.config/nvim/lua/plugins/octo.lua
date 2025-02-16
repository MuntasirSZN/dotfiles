return {
	dir = "~/projects/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("octo").setup({
			picker = "snacks",
		})
		vim.treesitter.language.register("markdown", "octo")
	end,
}
