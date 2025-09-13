return {
	"apple/pkl-neovim",
	lazy = true,
	ft = "pkl",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter",
			build = function(_)
				vim.cmd("TSUpdate")
			end,
		},
		"L3MON4D3/LuaSnip",
	},
	build = function()
		require("pkl-neovim").init()

		-- Set up syntax highlighting.
		vim.cmd("TSInstall pkl")
	end,
	config = function()
		-- Set up snippets.
		require("luasnip.loaders.from_snipmate").lazy_load()

		-- Configure pkl-lsp
		vim.g.pkl_neovim = {
			-- or if pkl-lsp is installed with brew:
			start_command = { vim.fn.stdpath("data") .. "/mason/bin/pkl-lsp" },
			pkl_cli_path = "/home/muntasir/.local/share/mise/installs/pkl/0.29.0/pkl",
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "pkl",
			callback = function()
				vim.treesitter.start()
			end,
		})
	end,
}
