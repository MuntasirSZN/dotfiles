return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	opts = function()
		local servers = {
			astro = {},
			bashls = {},
			biome = {},
			cssls = {},
			css_variables = {},
			cssmodules_ls = {},
			docker_compose_language_service = {},
			dockerls = {},
			dotls = {},
			emmet_language_server = {},
			eslint = {},
			hyprls = {},
			jsonls = {},
			lua_ls = {
				settings = {
					lua_ls = {
						format = {
							enable = false,
						},
					},
				},
			},
			markdown_oxide = {},
			marksman = {},
			mdx_analyzer = {},
			prismals = {},
			pylsp = {},
			tailwindcss = {},
			yamlls = {},
			typos_lsp = {},
			["bacon_ls"] = {},
		}

		return {
			servers = servers,
		}
	end,

	config = function(_, opts)
		for server, config in pairs(opts.servers) do
			local on_attach = function(client, bufnr)
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(vim.lsp.inlay_hint.is_enabled({}), { bufnr = bufnr })
				end

				if client.server_capabilities.inlayHintProvider then
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
				end
			end

			config.on_attach = on_attach

			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			config.capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			config.capabilities.textDocument.inlayHint = {
				enable = true,
			}
			vim.lsp.inlay_hint.enable(true)
			require("lspconfig")[server].setup(config)
		end
	end,
}
