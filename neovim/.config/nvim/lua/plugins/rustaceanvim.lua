return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	event = "VeryLazy",
	config = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							enable = false,
						},
						diagnostics = {
							enable = false,
						},
						cargo = {
							allFeatures = true,
						},
					},
				},
			},
		}
	end,
}
