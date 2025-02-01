return {
	{

		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cM", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			ui = {
				icons = {
					package_installed = " ",
					package_pending = " ",
					package_uninstalled = " ",
				},
			},
			ensure_installed = {
				"stylua",
				"shfmt",
				"biome",
				"eslint_d",
				"biome",
				"eslint_d",
				"gitleaks",
				"hadolint",
				"markdownlint-cli2",
				"mypy",
				"pylint",
				"yamllint",
				"black",
				"markdown-toc",
				"mdformat",
				"prettierd",
				"sqlfmt",
				"yamlfmt",
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
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
			"nvimdev/lspsaga.nvim",
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
			}

			return {
				servers = servers,
			}
		end,

		config = function(_, opts)
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				require("lspconfig")[server].setup(config)
			end
		end,
	},
	-- Typescript
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"mdx",
				},
			})
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},
}
