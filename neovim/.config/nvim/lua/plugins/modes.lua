return {
	"mvllow/modes.nvim",
	event = "BufReadPre",
	lazy = false,
	config = function()
		require("modes").setup()
	end,
}
