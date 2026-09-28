return {
  "catgoose/nvim-colorizer.lua",
  branch = "feat/rehighlight_events",

  event = "BufReadPre",
  opts = {
    filetypes = {
      "*",
      typescript = { rehighlight_events = { "CursorHold" } },
      typescriptreact = { rehighlight_events = { "CursorHold" } },
      "!Trouble",
      "!alpha",
      "!dashboard",
      "!fzf",
      "!help",
      "!lazy",
      "!mason",
      "!neo-tree",
      "!notify",
      "!snacks_dashboard",
      "!snacks_notif",
      "!snacks_terminal",
      "!snacks_win",
      "!toggleterm",
      "!trouble",
    },
    rehighlight_events = { "CursorMoved", "CursorMovedI" },
    hooks = {
      should_highlight_line = function(line, bufnr, line_nr)
        -- Skip concealed lines unless cursor is on them
        local win = vim.fn.bufwinid(bufnr)
        if win == -1 then
          return true
        end
        if vim.wo[win].conceallevel < 2 then
          return true
        end
        local cursor_line = vim.api.nvim_win_get_cursor(win)[1] - 1
        if line_nr == cursor_line then
          return true
        end
        local col = line:find("%S")
        if col and vim.fn.synconcealed(line_nr + 1, col)[1] == 1 then
          return false
        end
        return true
      end,
    },
    options = {
      parsers = {
        css = true, -- preset: enables names, hex, rgb, hsl, oklch, css_var
        css_fn = true, -- preset: enables rgb, hsl, oklch
        names = {
          enable = true, -- enable named colors (e.g. "Blue")
          lowercase = true, -- match lowercase names
          camelcase = true, -- match CamelCase names (e.g. "LightBlue")
          uppercase = false, -- match UPPERCASE names
          strip_digits = false, -- ignore names with trailing digits (e.g. "blue3")
          custom = false, -- custom name-to-hex mappings; table|function|false
        },
        hex = {
          default = true, -- default value for unset format keys (see above)
          rgb = true, -- #RGB (3-digit)
          rgba = true, -- #RGBA (4-digit)
          rrggbb = true, -- #RRGGBB (6-digit)
          rrggbbaa = true, -- #RRGGBBAA (8-digit)
          hash_aarrggbb = true, -- #AARRGGBB (QML-style, alpha first)
          aarrggbb = true, -- 0xAARRGGBB
          no_hash = false, -- hex without '#' at word boundaries
        },
        rgb = { enable = true }, -- rgb()/rgba() functions
        hsl = { enable = true }, -- hsl()/hsla() functions
        oklch = { enable = true }, -- oklch() function
        tailwind = {
          enable = true, -- parse Tailwind color names
          update_names = true, -- feed LSP colors back into name parser (requires both enable + lsp.enable)
        },
        sass = {
          enable = true, -- parse Sass color variables
          parsers = { css = true }, -- parsers for resolving variable values
        },
        xterm = { enable = true }, -- xterm 256-color codes (#xNN, \e[38;5;NNNm)
        xcolor = { enable = true }, -- LaTeX xcolor expressions (e.g. red!30)
        hsluv = { enable = true }, -- hsluv()/hsluvu() functions
        css_var_rgb = { enable = true }, -- CSS vars with R,G,B (e.g. --color: 240,198,198)
        css_var = {
          enable = true, -- resolve var(--name) references to their defined color
          parsers = { css = true }, -- parsers for resolving variable values
        },
      },
      display = {
        mode = "virtualtext", -- "background"|"foreground"|"virtualtext"
        virtualtext = {
          char = require("config.icons").misc.color_text, -- character used for virtualtext
          position = "before", -- "eol"|"before"|"after"
        },
      },
    },
  },
}
