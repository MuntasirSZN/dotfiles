return {
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		lazy = true,
		event = "VeryLazy",
		config = function()
			local theme_colors = require("catppuccin.palettes").get_palette()
			require("tiny-devicons-auto-colors").setup({
				theme_colors = theme_colors,
			})
		end,
	},
}
