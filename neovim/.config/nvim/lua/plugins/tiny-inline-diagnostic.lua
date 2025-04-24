return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "BufReadPre",
	lazy = true,
	priority = 2000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = {
					-- Enable multiline diagnostic messages
					enabled = true,

					-- Always show messages on all lines for multiline diagnostics
					always_show = true,
				},
			},
		})
	end,
}
