return {
	"lazymaniac/wttr.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		location = "Chittagong",
		format = 1,
	},
	keys = {
		{
			"<leader>W",
			function()
				require("wttr").get_forecast() -- show forecast for my location
			end,
			desc = "Weather Forecast",
		},
	},
}
