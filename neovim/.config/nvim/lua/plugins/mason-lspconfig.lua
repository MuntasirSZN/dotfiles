return {
	"mason-org/mason-lspconfig.nvim",
	lazy = false,
	event = "VimEnter",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local servers = require("plugins.lspconfig").opts().servers

		local ignore = { clangd = true }

		local all = vim.tbl_keys(servers)
		local filtered = vim.tbl_filter(function(name)
			return not ignore[name]
		end, all)

		require("mason-lspconfig").setup({
			ensure_installed = filtered,
			automatic_installation = false, -- (correct field name)
		})
	end,
}
