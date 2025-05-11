return {
	"mason-org/mason-lspconfig.nvim",
	lazy = false,
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local servers = require("plugins.lspconfig").opts().servers
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})
	end,
}
