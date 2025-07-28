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
			vtsls = {},
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

		-- Vue Setup
		local vue_language_server_path = vim.fn.expand("~/.local/share/nvim/mason/packages")
			.. "/vue-language-server"
			.. "/node_modules/@vue/language-server"
		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}
		local vtsls_config = {
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							vue_plugin,
						},
					},
				},
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		}

		local vue_ls_config = {
			on_init = function(client)
				client.handlers["tsserver/request"] = function(_, result, context)
					local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
					if #clients == 0 then
						vim.notify(
							"Could not find `vtsls` lsp client, `vue_ls` would not work without it.",
							vim.log.levels.ERROR
						)
						return
					end
					local ts_client = clients[1]

					local param = unpack(result)
					local id, command, payload = unpack(param)
					ts_client:exec_cmd({
						title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
						command = "typescript.tsserverRequest",
						arguments = {
							command,
							payload,
						},
					}, { bufnr = context.bufnr }, function(_, r)
						local response_data = { { id, r.body } }
						---@diagnostic disable-next-line: param-type-mismatch
						client:notify("tsserver/response", response_data)
					end)
				end
			end,
		}

		vim.lsp.config("vtsls", vtsls_config)
		vim.lsp.config("vue_ls", vue_ls_config)
	end,
}
