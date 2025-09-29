return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	lazy = false,
	config = function()
		vim.api.nvim_create_autocmd({ "FileType", "BufAdd", "BufEnter" }, {
			pattern = "*",
			callback = function()
				local excluded_filetypes = {
					"trouble",
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
					"BlinkCmpMenu",
				}

				local excluded_ft_lookup = {}
				for _, ft in ipairs(excluded_filetypes) do
					excluded_ft_lookup[ft] = true
				end

				-- Set up excluded buffer types
				local excluded_buftypes = {
					["nofile"] = true,
					["terminal"] = true,
				}

				local current_ft = vim.bo.filetype
				local current_bt = vim.bo.buftype

				if excluded_ft_lookup[current_ft] or excluded_buftypes[current_bt] then
					vim.opt_local.foldcolumn = "0"
					vim.opt_local.foldenable = false
				else
					vim.opt_local.foldcolumn = "1"
					vim.opt_local.foldenable = true
				end
			end,
		})

		require("origami").setup({
			foldtext = {
				lineCount = {
					template = "...",
				},
			},
		})
	end,
}
