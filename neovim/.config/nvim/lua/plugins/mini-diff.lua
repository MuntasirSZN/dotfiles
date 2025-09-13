return {
	"nvim-mini/mini.diff",
	version = "*",
	lazy = false,
	config = function()
		local diff = require("mini.diff")
		diff.setup({
			source = diff.gen_source.none(),
		})
	end,
}
