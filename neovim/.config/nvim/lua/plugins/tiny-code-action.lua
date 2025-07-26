return {
	"rachartier/tiny-code-action.nvim",
	-- enabled = false,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
	event = "LspAttach",
	opts = {
		backend = "delta",
		picker = {
			"buffer",
			opts = {
				auto_preview = true,
			},
		},
	},
	keys = {
		{
			"<leader>cl",
			function()
				require("tiny-code-action").code_action()
			end,
			desc = "Code Action",
		},
	},
}
