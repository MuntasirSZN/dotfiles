return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = function()
		---@module "conform"
		---@type conform.setupOpts
		local opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "mdformat" },
				sh = { "shfmt" },
				sql = { "sqlfmt" },
				yaml = { "yamlfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				protobuf = { "clang_format" },
				python = { "ruff_format", "ruff_organize_imports" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
			formatters = {
				shfmt = {
					append_args = { "-w", "-i", "2" },
				},
			},
		}

		local function is_installed(dir_name)
			local cwd = vim.fn.getcwd()
			local found = vim.fs.find(dir_name, { path = cwd, upward = true, type = "directory" })
			return not vim.tbl_isempty(found)
		end

		local prettier_installed = is_installed("node_modules/prettier")
		local biome_installed = is_installed("node_modules/@biomejs/biome")
		local eslint_plugin_format_installed = is_installed("node_modules/eslint-plugin-format")

		if prettier_installed and not eslint_plugin_format_installed then
			local conf = { "prettierd", "prettier", stop_after_first = true }
			opts.formatters_by_ft["*"] = conf
		end

		if biome_installed then
			opts.formatters_by_ft["*"] = { "biome", "biome-organize-imports" }
		end

		return opts
	end,
}
