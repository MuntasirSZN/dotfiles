return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_terminal" } },
			},
			sections = {
				lualine_x = {
					{
						function()
							return require("lazydo").get_lualine_stats() -- status
						end,
						cond = function()
							return require("lazydo")._initialized -- condition for lualine
						end,
					},
					{
						"copilot",
						show_colors = true,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
			extensions = {
				"lazy",
				"man",
				"mason",
				"quickfix",
				"neo-tree",
				"nvim-dap-ui",
				"trouble",
			},
		})
	end,
}
