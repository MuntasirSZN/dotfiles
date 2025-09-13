return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
	},
	opts = function()
		local servers = {
			astro = {},
			bashls = {},
			biome = {},
			cssls = {
				settings = {
					css = {
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			},
			css_variables = {},
			cssmodules_ls = {},
			docker_compose_language_service = {},
			dockerls = {},
			dotls = {},
			emmet_language_server = {},
			eslint = {},
			hyprls = {},
			jsonls = {},
			just = {},
			clangd = {},
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
			pyright = {},
			prismals = {},
			tailwindcss = {},
			ruff = {},
			yamlls = {},
			typos_lsp = {},
			vimls = {},
			html = {},
			ty = {},
			oxlint = {},
			tombi = {},
			vue_ls = {},
			zls = {},
			vtsls = {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = vim.fn.stdpath("data")
										.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
									languages = { "vue" },
									configNamespace = "typescript",
								},
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			},
			harper_ls = {
				enabled = true,
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
				if client.server_capabilities.semanticTokensProvider then
					client.server_capabilities.semanticTokensProvider.full = true
				end
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

			config.capabilities = require("blink.cmp").get_lsp_capabilities()
			config.capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			config.capabilities.textDocument.inlayHint = {
				enable = true,
			}
			if server == "cssls" then
				config.capabilities.textDocument.completion.completionItem.snippetSupport = true
			end
			vim.lsp.inlay_hint.enable(true)
			vim.lsp.enable(server)
			vim.lsp.config(server, config)
			vim.lsp.enable("qmlls")
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

		vim.lsp.config("eslint", {
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
