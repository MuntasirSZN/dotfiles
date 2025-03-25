return {
	"2kabhishek/nerdy.nvim",
	dependencies = {
		"folke/snacks.nvim",
	},
	cmd = "Nerdy",
	keys = {
		{
			"<leader>ce",
			function()
				vim.cmd("Nerdy")
			end,
			desc = "Find Nerd Icons",
		},
	},
}
