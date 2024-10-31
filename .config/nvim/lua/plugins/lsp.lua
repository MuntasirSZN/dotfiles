return {
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"phpactor",
					"cssls",
					"clangd",
					"cmake",
					"rust_analyzer",
					"julials",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"emmet_language_server",
					"lua_ls",
					"html",
					"ts_ls",
					"autotools_ls",
					"markdown_oxide",
					"pylsp",
					"tailwindcss",
					"yamlls",
					"jsonls",
					"biome",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			local servers = {
				"bashls",
				"phpactor",
				"cssls",
				"clangd",
				"cmake",
				"rust_analyzer",
				"julials",
				"dockerls",
				"docker_compose_language_service",
				"eslint",
				"emmet_language_server",
				"lua_ls",
				"html",
				"ts_ls",
				"autotools_ls",
				"markdown_oxide",
				"pylsp",
				"tailwindcss",
				"yamlls",
				"jsonls",
				"biome",
			}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					-- on_attach = my_custom_on_attach,
					capabilities = capabilities,
				})
			end
			local luasnip = require("luasnip")
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}),
			})
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- snippets support
					null_ls.builtins.completion.luasnip,
				},
			})

			---@class PluginLspOpts
			local ret = {
				-- options for vim.diagnostic.config()
				---@type vim.diagnostic.Opts
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = {
						spacing = 4,
						source = "if_many",
						prefix = "●",
						-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
						-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
						-- prefix = "icons",
					},
					severity_sort = true,
					signs = {
						text = {
							[vim.diagnostic.severity.WARN] = " ",
							[vim.diagnostic.severity.ERROR] = " ",
							[vim.diagnostic.severity.HINT] = " ",
							[vim.diagnostic.severity.INFO] = " ",
						},
					},
				},
				inlay_hints = {
					enabled = true,
					exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
				},
				codelens = {
					enabled = false,
				},
				-- Enable lsp cursor word highlighting
				document_highlight = {
					enabled = true,
				},
				-- add any global capabilities here
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
				format = {
					formatting_options = nil,
					timeout_ms = nil,
				},
			}
			return ret
		end,
		config = function()
      require("lspconfig").clangd.setup({})
			require("lspconfig").cmake.setup({})
			require("lspconfig").emmet_language_server.setup({})
			require("lspconfig").dockerls.setup({})
			require("lspconfig").eslint.setup({})
			require("lspconfig").html.setup({})
			require("lspconfig").jsonls.setup({})
			require("lspconfig").lua_ls.setup({})
			require("lspconfig").ts_ls.setup({})
			require("lspconfig").yamlls.setup({})
			require("lspconfig").biome.setup({})
			require("lspconfig").tailwindcss.setup({})
			require("lspconfig").docker_compose_language_service.setup({})
			require("lspconfig").cssls.setup({})
			require("lspconfig").bashls.setup({})
			require("lspconfig").phpactor.setup({})
			require("lspconfig").julials.setup({})
			require("lspconfig").markdown_oxide.setup({})
			require("lspconfig").pylsp.setup({})
			require("lspconfig").autotools_ls.setup({})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>ch", "", desc = "+Call Hierarchy" },
			{ "<leader>chi", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming Calls" },
			{ "<leader>cho", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing Calls" },
			{ "<leader>cl", "<cmd>Lspsaga code_action<cr>", desc = "Code Actions" },
			{ "<leader>cd", "", desc = "+definition" },
			{ "<leader>cdp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
			{ "<leader>cdt", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
			{ "<leader>cdg", "<cmd>Lspsaga goto_definition<cr>", desc = "Go To Definition" },
			{ "<leader>cdj", "<cmd>Lspsaga peek_definition<cr>", desc = "Go To Type Definition" },
			{ "<leader>ci", "", desc = "+diagnostics" },
			{ "<leader>cij", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Jump To Next Diagnostic" },
			{ "<leader>cip", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Jump To Previous Diagnostic" },
			{ "<leader>cq", "<cmd>Lspsaga finder<cr>", desc = "Finder" },
			{ "<leader>ct", "<cmd>Lspsaga term_toggle<cr>", desc = "Terminal" },
			{ "<leader>co", "<cmd>Lspsaga hover_doc<cr>", desc = "Documentation" },
			{ "<leader>ck", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "Keep Documentation Pinned" },
			{ "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					devicon = true,
				},
				lightbulb = {
					enable = false,
				},
			})
		end,
	},
}
