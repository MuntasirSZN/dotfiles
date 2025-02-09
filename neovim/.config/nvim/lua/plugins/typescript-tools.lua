return -- Typescript
{
	"pmizio/typescript-tools.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		require("typescript-tools").setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"mdx",
			},
		})
	end,
}
