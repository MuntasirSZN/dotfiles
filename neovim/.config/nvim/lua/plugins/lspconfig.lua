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
			vimls = {},
			harper_ls = {
				enabled = true,
				filetypes = { "markdown" },
				settings = {
					["harper-ls"] = {
						userDictPath = "~/.config/nvim/spell/en.utf-8.add",
						linters = {
							ToDoHyphen = false,
							-- SentenceCapitalization = true,
							-- SpellCheck = true,
						},
						isolateEnglish = true,
						markdown = {
							-- [ignores this part]()
							-- [[ also ignores my marksman links ]]
							IgnoreLinkTitle = true,
						},
					},
				},
			},
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

		local customizations = {
			{ rule = "style/*", severity = "off", fixable = true },
			{ rule = "format/*", severity = "off", fixable = true },
			{ rule = "*-indent", severity = "off", fixable = true },
			{ rule = "*-spacing", severity = "off", fixable = true },
			{ rule = "*-spaces", severity = "off", fixable = true },
			{ rule = "*-order", severity = "off", fixable = true },
			{ rule = "*-dangle", severity = "off", fixable = true },
			{ rule = "*-newline", severity = "off", fixable = true },
			{ rule = "*quotes", severity = "off", fixable = true },
			{ rule = "*semi", severity = "off", fixable = true },
		}

		local lspconfig = require("lspconfig")
		-- Enable eslint for all supported languages
		lspconfig.eslint.setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
				"html",
				"markdown",
				"json",
				"jsonc",
				"yaml",
				"toml",
				"xml",
				"gql",
				"graphql",
				"astro",
				"svelte",
				"css",
				"less",
				"scss",
				"pcss",
				"postcss",
			},
			settings = {
				-- Silent the stylistic rules in you IDE, but still auto fix them
				rulesCustomizations = customizations,
			},
		})
	end,
}
