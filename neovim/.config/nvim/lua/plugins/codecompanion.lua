return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
	},
	config = function()
		vim.g.codecompanion_auto_tool_mode = true
		vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<LocalLeader>a",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<LocalLeader>a",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

		-- Expand 'cc' into 'CodeCompanion' in the command line
		vim.cmd([[cab cc CodeCompanion]])
		require("codecompanion").setup({
			extensions = {
				vectorcode = {
					opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
				},
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
						make_vars = true, -- make chat #variables from MCP server resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				},
			},
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
				agent = {
					adapter = "copilot",
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.7-sonnet",
							},
						},
					})
				end,
			},
		})
	end,
}
