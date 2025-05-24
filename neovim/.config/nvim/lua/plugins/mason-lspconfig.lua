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
		local tbl_keys = vim.tbl_keys(servers)
		require("mason-lspconfig").setup({
			ensure_installed = tbl_keys,
		})

		local registry = require("mason-registry")
		for server in ipairs(servers) do
			if not registry.has_package(server) then
				vim.cmd("LspInstall " .. server)
			end
		end
	end,
}
