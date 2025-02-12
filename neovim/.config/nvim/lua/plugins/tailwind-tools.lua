return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	build = ":UpdateRemotePlugins",
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("tailwind-tools").setup({
			conceal = {
				enabled = true,
			},
			document_color = {
				inline_symbol = "󱓻 ",
			},
		})
	end,
}
