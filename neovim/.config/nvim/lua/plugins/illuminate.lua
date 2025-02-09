return {
	"RRethy/vim-illuminate",
	event = "InsertEnter",
	config = function()
		require("illuminate").configure({
			filetypes_denylist = {
				"dirbuf",
				"dirvish",
				"fugitive",
				"dashboard",
				"neo-tree",
				"TelescopePrompt",
				"snacks",
				"snacks_dashboard",
			},
		})
	end,
}
