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
		local latest_command_type = ""
		local latest_command = nil

		local function run_nearest_codelens()
			local current_line = vim.fn.line(".") - 1
			local nearest_codelens_line = current_line
			local height = math.huge

			for _, codelens in pairs(vim.lsp.codelens.get()) do
				local start_line = codelens.command.arguments[4].start_line
				local end_line = codelens.command.arguments[4].end_line

				if start_line <= current_line and current_line <= end_line then
					local my_height = end_line - start_line
					if my_height < height then
						nearest_codelens_line = start_line + 1
						height = my_height
					end
				end
			end

			-- I would like to just pass a line number to vim.api.codelens.run, but it
			-- doesn't work that way, and I don't want to recreate it, so let's just move
			-- the cursor up.
			vim.api.nvim_win_set_cursor(0, { nearest_codelens_line, 0 })
			vim.lsp.codelens.run()
		end

		local function rerun_latest_codelens()
			local latest_handler = vim.lsp.commands[latest_command_type]

			if latest_handler then
				latest_handler(latest_command)
			else
				run_nearest_codelens()
			end
		end

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

					vim.keymap.set("n", "<leader>l", run_nearest_codelens)
					vim.keymap.set("n", "<leader>L", rerun_latest_codelens)
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
