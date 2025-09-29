return {
	"xzbdmw/colorful-menu.nvim",
	event = "InsertEnter",
	lazy = false,
	config = function()
		require("colorful-menu").setup({})
	end,
}
