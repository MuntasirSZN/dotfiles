return {
	"okuuva/auto-save.nvim",
	version = "*",
	cmd = "ASToggle",
	lazy = true,
	keys = {
		{ "<leader>n", "<cmd>ASToggle<cr>", desc = "Toggle auto-save" },
	},
	opts = {
		enabled = false,
	},
}
