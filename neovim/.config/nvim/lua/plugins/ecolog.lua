return {
	"philosofonusus/ecolog.nvim",
	-- Optional: you can add some keybindings
	keys = {
		{
			"<leader>cE",
			function() end,
			desc = "Ecolog",
		},
		{ "<leader>gE", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
		{ "<leader>cEp", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
		{ "<leader>cEs", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
		{ "<leader>cEs", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog shelter toggle" },
		{ "<leader>cEc", "<cmd>EcologSnacks<cr>", desc = "Open a picker" },
		{ "<leader>cEl", "<Cmd>EcologShelterLinePeek<cr>", desc = "Ecolog peek line" },
		{ "<leader>cEh", "<Cmd>EcologShellToggle<cr>", desc = "Toggle shell variables" },
	},
	-- Lazy loading is done internally
	lazy = false,
	opts = {
		interpolation = {
			enabled = true,
			features = {
				commands = false,
			},
		},
		integrations = {
			snacks = true,
			-- WARNING: for both cmp integrations see readme section below
			nvim_cmp = false, -- If you dont plan to use nvim_cmp set to false, enabled by default
			-- If you are planning to use blink cmp uncomment this line
			blink_cmp = true,
			statusline = {
				hidden_mode = true, -- Hide when no env file is loaded
				icons = {
					enabled = true, -- Enable icons in statusline
					env = require("custom.icons").misc.env, -- Icon for environment file
					shelter = require("custom.icons").misc.shelter_env, -- Icon for shelter mode
				},
				format = {
					env_file = function(name)
						return name -- Format environment file name
					end,
					vars_count = function(count)
						return string.format("%d", count) -- Format variables count
					end,
				},
				highlights = {
					enabled = true, -- Enable custom highlights
					env_file = "Directory", -- Highlight group for file name
					vars_count = "Number", -- Highlight group for vars count
					icons = {
						env = "#428890", -- Hex color for env icon
						shelter = "#F9E2AE", -- Hex color for shelter icon
					},
				},
			},
		},
		-- Enables shelter mode for sensitive values
		shelter = {
			configuration = {
				-- Partial mode configuration:
				-- false: completely mask values (default)
				-- true: use default partial masking settings
				-- table: customize partial masking
				-- partial_mode = false,
				-- or with custom settings:
				partial_mode = {
					show_start = 3, -- Show first 3 characters
					show_end = 3, -- Show last 3 characters
					min_mask = 3, -- Minimum masked characters
				},
				mask_char = require("custom.icons").misc.env_mask_char, -- Character used for masking
				mask_length = nil, -- Optional: fixed length for masked portion (defaults to value length)
			},
			modules = {
				cmp = true, -- Enabled to mask values in completion
				peek = false, -- Enable to mask values in peek view
				files = true, -- Enabled to mask values in file buffers
				telescope = false, -- Enable to mask values in telescope integration
				telescope_previewer = false, -- Enable to mask values in telescope preview buffers
				fzf = false, -- Enable to mask values in fzf picker
				fzf_previewer = false, -- Enable to mask values in fzf preview buffers
				snacks_previewer = true, -- Enable to mask values in snacks previewer
				snacks = false, -- Enable to mask values in snacks picker
			},
		},
		-- true by default, enables built-in types (database_url, url, etc.)
		types = true,
		path = vim.fn.getcwd(), -- Path to search for .env files
		preferred_environment = "local", -- Optional: prioritize specific env files
		-- Controls how environment variables are extracted from code and how cmp works
		provider_patterns = true, -- true by default, when false will not check provider patterns
	},
}
