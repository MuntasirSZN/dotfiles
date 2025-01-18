return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			marks = {
				Cursor = {
					text = " ",
				},
			},
		})
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
