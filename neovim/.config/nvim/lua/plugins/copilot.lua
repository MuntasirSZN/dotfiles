return {
	"zbirenbaum/copilot.lua",
	lazy = false,
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
				},
			},
			filetypes = {
				["*"] = true,
			},
			workspace_folders = {
				"/home/muntasir/projects",
			},
			should_attach = function(_, bufname)
				if string.match(bufname, "env") then
					return false
				end

				return true
			end,
			server = {
				type = "binary",
			},
		})
	end,
}
