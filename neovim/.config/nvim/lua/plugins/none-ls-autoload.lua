return {
	"zeioth/none-ls-autoload.nvim",
	event = "VeryLazy",
	dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
	opts = {
		methods = {
			formatting = false,
		},
	},
}
