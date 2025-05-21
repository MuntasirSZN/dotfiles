return {
	"Chaitanyabsprip/fastaction.nvim",
	event = "BufReadPre",
	keys = {
		{
			"<leader>cl",
			function()
				require("fastaction").code_action()
			end,
			desc = "Code Actions",
		},
	},
	---@type FastActionConfig
	opts = {},
}
