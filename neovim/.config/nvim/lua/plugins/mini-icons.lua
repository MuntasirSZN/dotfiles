return {
	"echasnovski/mini.icons",
	lazy = true,
	event = "VeryLazy",
	opts = function()
		local test_icon = ""
		local js_table = { glyph = test_icon, hl = "MiniIconsYellow" }
		local jsx_table = { glyph = test_icon, hl = "MiniIconsAzure" }
		local ts_table = { glyph = test_icon, hl = "MiniIconsAzure" }
		local tsx_table = { glyph = test_icon, hl = "MiniIconsBlue" }

		return {
			directory = {
				[".git"] = { glyph = "󰊢", hl = "MiniIconsOrange" },
				[".github"] = { glyph = "󰊤", hl = "MiniIconsAzure" },
			},
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
				README = { glyph = "󰈙", hl = "MiniIconsYellow" },
				["README.md"] = { glyph = "󰈙", hl = "MiniIconsYellow" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
			extension = {
				js = { icon = "󰌞", name = "js" },
				ts = { icon = "󰛦", name = "ts" },
				lock = { icon = "󰌾", name = "lock" },
				["robots.txt"] = { icon = "󰚩", name = "robots" },
				["test.js"] = js_table,
				["test.jsx"] = jsx_table,
				["test.ts"] = ts_table,
				["test.tsx"] = tsx_table,
				["spec.js"] = js_table,
				["spec.jsx"] = jsx_table,
				["spec.ts"] = ts_table,
				["spec.tsx"] = tsx_table,
			},
			lsp = {
				copilot = { glyph = "", hl = "MiniIconsGrey" },
				supermaven = { glyph = "", hl = "MiniIconsGrey" },
				calc = { glyph = "󰃬", hl = "MiniIconsGrey" },
				codecompanion = { glyph = "󰚩", hl = "MiniIconsGrey" },
				gemini = { glyph = "⯌", hl = "MiniIconsGrey" },
				claude = { glyph = "", hl = "MiniIconsGrey" },
				ellipsis_char = { glyph = "… ", hl = "MiniIconsGrey" },
				codeium = { glyph = "", hl = "MiniIconsGray" },
				anthropic = { glyph = "", hl = "MiniIconsGray" },
				openai = { glyph = "󰊲", hl = "MiniIconsGrey" },
				groq = { glyph = "", hl = "MiniIconsGrey" },
				xai = { glyph = "", hl = "MiniIconsGrey" },
				huggingface = { glyph = "", hl = "MiniIconsGrey" },
			},
		}
	end,
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
