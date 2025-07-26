return {
	"nvzone/floaterm",
	dependencies = "nvzone/volt",
	opts = {},
	cmd = "FloatermToggle",
	keys = {
		{
			"<leader>cF",
			function()
				vim.cmd([[FloatermToggle]])
			end,
			desc = "Toggle Floaterm",
		},
	},
}
