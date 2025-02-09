return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"css",
				"ruby",
				"rust",
			},
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(lang)
					local allowed_filetypes = { "markdown", "vimwiki", "norg", "rst", "markdown_inline" }
					for _, filetype in ipairs(allowed_filetypes) do
						if lang == filetype then
							return false -- Do not disable highlighting for these file types
						end
					end
					return true -- Disable highlighting for all other file types
				end,
			},
		})
	end,
}
