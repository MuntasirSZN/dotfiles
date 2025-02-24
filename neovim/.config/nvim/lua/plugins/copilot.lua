return {
	"MuntasirSZN/copilot.lua",
	event = "BufEnter",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				enabled = false,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
				},
			},
			server_opts_overrides = {
				trace = "verbose",
				cmd = {
					vim.fn.expand("~/.local/share/nvim/mason/bin/copilot-language-server"),
					"--stdio",
				},
				settings = {
					advanced = {
						listCount = 10,
						inlineSuggestionCount = 3,
					},
				},
			},
			filetypes = {
				["*"] = true,
			},
		})
	end,
}
