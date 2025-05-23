return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		"ravitemer/codecompanion-history.nvim",
	},
	init = function()
		require("custom.codecompanion-notification").init()
	end,
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
			display = {
				action_palette = {
					provider = "snacks",
				},
			},
			extensions = {
				history = {
					enabled = true,
					opts = {
						-- Keymap to open history from chat buffer (default: gh)
						keymap = "gh",
						-- Keymap to save the current chat manually (when auto_save is disabled)
						save_chat_keymap = "sc",
						-- Save all chats by default (disable to save only manually using 'sc')
						auto_save = true,
						-- Number of days after which chats are automatically deleted (0 to disable)
						expiration_days = 0,
						-- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
						picker = "snacks",
						-- Automatically generate titles for new chats
						auto_generate_title = true,
						---On exiting and entering neovim, loads the last chat on opening chat
						continue_last_chat = false,
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = false,
						---Directory path to save the chats
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						---Enable detailed logging for history extension
						enable_logging = false,
					},
				},
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
					roles = {
						llm = function(adapter)
							local icon = require("mini.icons").get(
								"lsp",
								adapter.name == "anthropic" and "claude" or adapter.name
							)
							return " " .. icon .. "  " .. adapter.formatted_name
						end,
						user = "  Me",
					},
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
								default = "claude-4-sonnet",
							},
						},
					})
				end,
			},
		})
	end,
}
