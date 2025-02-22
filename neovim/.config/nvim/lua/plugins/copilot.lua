return {
	"MuntasirSZN/copilot.lua",
	event = "BufEnter",
	lazy = false,
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
				yaml = true,
				markdown = true,
				help = true,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = false,
				["."] = true,
			},
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			callback = function(args)
				local active_clients = vim.lsp.get_clients()

				-- Check if copilot is among the active clients
				local copilot_attached = false
				for _, client in ipairs(active_clients) do
					if client.name == "copilot" then
						copilot_attached = true
						break
					end
				end

				if copilot_attached then
					vim.cmd([[ Copilot detach ]])
				else
					vim.bo[args.buf].buflisted = true
					vim.cmd([[ Copilot! attach ]])
				end
			end,
		})
	end,
}
