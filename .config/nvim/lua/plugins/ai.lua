return {
	{ "github/copilot.vim" },
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- The following are optional:
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
		},
		config = function()
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
				strategies = {
					chat = {
						adapter = "openai_compatible",
					},
					inline = {
						adapter = "openai_compatible",
					},
					agent = {
						adapter = "openai_compatible",
					},
				},
				adapters = {
					openai_compatible = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "https://glhf.chat",
								api_key = "cmd:op read op://personal/OpenAI/credential --no-newline",
								chat_url = "/api/openai/v1/chat/completions",
							},
							schema = {
								model = {
									-- Or any GLHF model!
									default = "hf:meta-llama/Meta-Llama-3.1-405B-Instruct",
								},
								num_ctx = {
									default = 32768,
								},
							},
						})
					end,
				},
			})
		end,
	},
}
