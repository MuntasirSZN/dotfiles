return {
	"ravitemer/mcphub.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
	},
	cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
	build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
	config = function()
		vim.g.mcphub_auto_approve = true
		require("mcphub").setup({
			use_bundled_binary = true, -- Use the bundled MCP binary
			extensions = {
				codecompanion = {
					-- Show the mcp tool result in the chat buffer
					-- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
					show_result_in_chat = true,
					make_vars = true, -- make chat #variables from MCP server resources
					make_slash_commands = true, -- make /slash_commands from MCP server prompts
				},
			},
		})
	end,
}
