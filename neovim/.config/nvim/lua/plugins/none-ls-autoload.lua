return {
	"zeioth/none-ls-autoload.nvim",
	event = "VeryLazy",
	dependencies = { "mason-org/mason.nvim", "nvimtools/none-ls.nvim" },
	opts = {
		methods = {
			formatting = false,
		},
	},
}
