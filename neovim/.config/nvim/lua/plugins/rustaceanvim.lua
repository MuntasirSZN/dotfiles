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
				cmd = function()
					local mason_registry = require("mason-registry")
					if mason_registry.is_installed("rust-analyzer") then
						-- This may need to be tweaked depending on the operating system.
						local ra = mason_registry.get_package("rust-analyzer")
						local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
						return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
					else
						-- global installation
						return { "rust-analyzer" }
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
