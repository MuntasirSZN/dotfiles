return {
	"MuntasirSZN/copilot.lua",
	event = "InsertEnter",
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
			workspace_folders = {
				"/home/muntasir/projects",
			},
			copilot_model = "gpt-4o-copilot",
		})
	end,
}
