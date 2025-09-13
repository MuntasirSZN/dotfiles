return {
	"soulis-1256/eagle.nvim",
	lazy = false,
	event = "BufReadPre",
	keys = {
		{
			"<leader>co",
			function()
				if Snacks.image.doc.at_cursor then
					Snacks.image.hover()
				end
				-- Eagle doesn't work with Cargo.toml files
				-- So use the defaults
				local filename = vim.fn.expand("%:t")
				local filetype = vim.bo.filetype
				if filename == "Cargo.toml" then
					vim.lsp.buf.hover()
				elseif filetype == "rust" then
					vim.cmd.RustLsp({ "hover", "actions" })
				else
					vim.cmd("EagleWin")
				end
			end,
			desc = "Documentation",
			silent = true,
		},
	},
	config = function()
		require("eagle").setup({
			show_headers = false,
			border = "rounded",
			keyboard_mode = true,
			mouse_mode = true,
			border_color = require("catppuccin.palettes").get_palette().surface1,
		})
	end,
}
