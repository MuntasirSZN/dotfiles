return {
	"zbirenbaum/copilot.lua",
	event = "BufEnter",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				enabled = false,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
				},
			},
			filetypes = {
				markdown = true,
				help = true,
			},
		})
	end,
}
