return {
	"mireq/luasnip-snippets",
	event = "VeryLazy",
	lazy = true,
	dependencies = { "L3MON4D3/LuaSnip" },
	init = function()
		-- Mandatory setup function
		lazy_require("luasnip_snippets.common.snip_utils").setup()
	end,
}
