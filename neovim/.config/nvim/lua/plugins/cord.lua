return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	lazy = false,
	event = "BufReadPre",
	opts = {
		plugins = {
			"cord.plugins.diagnostics",
		},
	},
}
