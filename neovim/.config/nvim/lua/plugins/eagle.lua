return {
	"soulis-1256/eagle.nvim",
	lazy = false,
	keys = {
		{
			"<leader>co",
			function()
				if Snacks.image.doc.at_cursor then
					Snacks.image.hover()
				end
				vim.cmd("EagleWin")
			end,
			desc = "Documentation",
		},
	},
	config = function()
		require("eagle").setup({
			border = "none",
			keyboard_mode = true,
		})
	end,
}
