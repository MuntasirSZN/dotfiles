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

		-- Attach copilot always
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			pattern = "*",
			callback = function()
				vim.cmd("Copilot! attach")
			end,
		})
	end,
}
