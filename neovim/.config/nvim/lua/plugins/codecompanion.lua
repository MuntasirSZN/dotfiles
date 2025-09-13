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
		require("custom.codecompanion-extmarks").setup()
		require("custom.codecompanion-notification").init()
		require("custom.codecompanion-spinner"):init()
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
			send = {
				callback = function(chat)
					vim.cmd("stopinsert")
					chat:add_buf_message({ role = "llm", content = "" })
					chat:submit()
				end,
				index = 1,
				description = "Send",
			},
			display = {
				action_palette = {
					provider = "snacks",
				},
			},
			extensions = {
				history = {
					enabled = true,
					opts = {
						picker = "snacks",
						auto_generate_title = true,
						title_generation_opts = {
							adapter = "copilot",
							model = "gpt-5-mini",
						},
						summary = {
							generation_opts = {
								adapter = "copilot",
								model = "gpt-5-mini",
							},
						},
					},
				},
				vectorcode = {
					opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
				},
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
				},
			},
			strategies = {
				chat = {
					tools = {
						opts = {
							auto_submit_errors = true,
							auto_submit_success = true,
						},
					},
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
				http = {
					openrouter = function()
						local openrouter = require("custom.codecompanion-openrouter")
						return require("codecompanion.adapters").extend(openrouter, {
							name = "openrouter",
							formatted_name = "Open Router",
							env = {
								api_key = "cmd:cat ~/.local/share/opencode/auth.json | jq -r .openrouter.key",
							},
							schema = {
								model = {
									default = "z-ai/glm-4.5-air:free",
								},
							},
						})
					end,
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "gpt-5",
								},
							},
						})
					end,
				},
			},
		})
	end,
}
