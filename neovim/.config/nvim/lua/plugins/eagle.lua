return {
	"soulis-1256/eagle.nvim",
	lazy = false,
	config = function()
		require("eagle").setup({
			border = "none",
		})
	end,
}
