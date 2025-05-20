return {
	"echasnovski/mini.operators",
	event = "VeryLazy",
	lazy = true,
	config = function()
		require("mini.operators").setup()
	end,
}
