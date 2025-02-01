return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 2000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					multilines = {
						-- Enable multiline diagnostic messages
						enabled = true,

						-- Always show messages on all lines for multiline diagnostics
						always_show = true,
					},
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup({})
			vim.keymap.set("n", "<leader>cl", function()
				require("tiny-code-action").code_action()
			end, { noremap = true, silent = true })
		end,
	},
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			local theme_colors = require("catppuccin.palettes").get_palette()
			require("tiny-devicons-auto-colors").setup({
				theme_colors = theme_colors,
			})
		end,
	},
}
