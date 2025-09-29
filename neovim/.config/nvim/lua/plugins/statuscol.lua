return {
	"luukvbaal/statuscol.nvim",
	lazy = false,
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			relculright = true,
			ft_ignore = {
				"Trouble",
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"notify",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
				"toggleterm",
				"trouble",
			},
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
				{ text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
			},
		})
	end,
}
