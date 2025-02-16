return {
	"Chaitanyabsprip/fastaction.nvim",
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
