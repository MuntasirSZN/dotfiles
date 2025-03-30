return {
	"saecki/crates.nvim",
	tag = "stable",
	opts = {
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	},
	init = function()
		local wk = require("which-key.config")
		local crates = require("crates")
		if vim.fn.expand("%:t") == "Cargo.toml" then
			wk.add({
				{ "<leader>cc", group = "Crates" },
				{ "<leader>cct", crates.toggle, desc = "Toggle" },
				{ "<leader>ccr", crates.reload, desc = "Reload" },

				{ "<leader>ccv", crates.show_versions_popup, desc = "Versions popup" },
				{ "<leader>ccf", crates.show_features_popup, desc = "Features popup" },
				{ "<leader>ccd", crates.show_dependencies_popup, desc = "Dependencies popup" },

				{ "<leader>ccu", crates.update_crate, desc = "Update crate" },
				{
					"<leader>ccu",
					crates.update_crates,
					desc = "Update selected crates",
					mode = "v",
				},
				{ "<leader>cca", crates.update_all_crates, desc = "Update all crates" },

				{ "<leader>ccU", crates.upgrade_crate, desc = "Upgrade crate" },
				{
					"<leader>ccU",
					crates.upgrade_crates,
					desc = "Upgrade selected crates",
					mode = "v",
				},
				{ "<leader>ccA", crates.upgrade_all_crates, desc = "Upgrade all crates" },

				{ "<leader>ccx", crates.expand_plain_crate_to_inline_table, desc = "Expand to inline table" },
				{ "<leader>ccX", crates.extract_crate_into_table, desc = "Extract into table" },
				{ "<leader>ccg", crates.use_git_source, desc = "Use git source" },

				{ "<leader>ccH", crates.open_homepage, desc = "Open homepage" },
				{ "<leader>ccR", crates.open_repository, desc = "Open repository" },
				{ "<leader>ccD", crates.open_documentation, desc = "Open documentation" },
				{ "<leader>ccC", crates.open_crates_io, desc = "Open crates.io" },
				{ "<leader>ccL", crates.open_lib_rs, desc = "Open lib.rs" },
			})
		end
	end,
}
