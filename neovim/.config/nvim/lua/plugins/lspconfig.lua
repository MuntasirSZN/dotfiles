return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	lazy = true,
	dependencies = {
		"saghen/blink.cmp",
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
