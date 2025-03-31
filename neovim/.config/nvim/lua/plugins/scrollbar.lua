return {
	"petertriho/nvim-scrollbar",
	lazy = false,
	config = function()
		require("scrollbar").setup({
			excluded_filetypes = {
				"dropbar_menu",
				"dropbar_menu_fzf",
				"DressingInput",
				"cmp_docs",
				"cmp_menu",
				"noice",
				"prompt",
				"TelescopePrompt",
				"Trouble",
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"notify",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
				"toggleterm",
				"trouble",
			},
			excluded_buftypes = {
				"terminal",
				"nofile",
			},
			marks = {
				Cursor = {
					text = " ",
				},
			},
		})
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
