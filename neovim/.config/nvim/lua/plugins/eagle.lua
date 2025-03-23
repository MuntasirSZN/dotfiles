return {
	"soulis-1256/eagle.nvim",
	lazy = false,
	keys = {
		{
			"<leader>co",
			function()
				if Snacks.image.doc.at_cursor then
					Snacks.image.hover()
				end
				vim.cmd("EagleWin")
				-- Eagle doesn't work with Cargo.toml files
				-- So use the defaults
				local filename = vim.fn.expand("%:t")
				if filename == "Cargo.toml" then
					vim.lsp.buf.hover()
				end
			end,
			desc = "Documentation",
		},
	},
	config = function()
		require("eagle").setup({
			show_headers = false,
			border = "none",
			keyboard_mode = true,
			mouse_mode = true,
		})
	end,
}
