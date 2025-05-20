return {
	"mrcjkb/rustaceanvim",
	version = "*",
	lazy = false, -- This plugin is already lazy
	event = "VeryLazy",
	config = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(client, bufnr)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(vim.lsp.inlay_hint.is_enabled({}), { bufnr = bufnr })
					end

					if client.server_capabilities.codeLensProvider then
						local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
						vim.api.nvim_create_autocmd({ "BufEnter" }, {
							group = codelens,
							callback = function()
								vim.lsp.codelens.refresh()
							end,
							buffer = bufnr,
							once = true,
						})
						vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
							group = codelens,
							callback = function()
								vim.lsp.codelens.refresh()
							end,
							buffer = bufnr,
						})

						vim.keymap.set("n", "<leader>l", function()
							vim.lsp.codelens.run()
						end)
					end
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
					},
				},
			},
		}
	end,
}
