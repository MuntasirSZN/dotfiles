return {
	"mcauley-penney/visual-whitespace.nvim",
	config = true,
	event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
	opts = {},
	init = function()
		-- vim.api.nvim_set_hl(0, "VisualNonText", { fg = require("modes"). })
	end,
}
