return {
  { "giuxtaposition/blink-cmp-copilot" },
  {
    "saghen/blink.cmp",
    lazy = false,
    build = "cargo build --release",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        enabled = true,
        opts = function(_, opts)
          local ls = require("luasnip")

          local s = ls.snippet
          local t = ls.text_node
          local i = ls.insert_node
          local f = ls.function_node

          local function clipboard()
            return vim.fn.getreg("+")
          end

          -- Custom snippets
          -- the "all" after ls.add_snippets("all" is the filetype, you can know a
          -- file filetype with :set ft
          -- Custom snippets

          -- #####################################################################
          --                            Markdown
          -- #####################################################################

          -- Helper function to create code block snippets
          local function create_code_block_snippet(lang)
            return s({
              trig = lang,
              name = "Codeblock",
              desc = lang .. " codeblock",
            }, {
              t({ "```" .. lang, "" }),
              i(1),
              t({ "", "```" }),
            })
          end

          -- Define languages for code blocks
          local languages = {
            "txt",
            "lua",
            "sql",
            "go",
            "regex",
            "bash",
            "markdown",
            "markdown_inline",
            "yaml",
            "json",
            "jsonc",
            "cpp",
            "csv",
            "java",
            "javascript",
            "python",
            "dockerfile",
            "html",
            "css",
            "templ",
            "php",
          }

          -- Generate snippets for all languages
          local snippets = {}

          for _, lang in ipairs(languages) do
            table.insert(snippets, create_code_block_snippet(lang))
          end

          table.insert(
            snippets,
            s({
              trig = "chirpy",
              name = "Disable markdownlint and prettier for chirpy",
              desc = "Disable markdownlint and prettier for chirpy",
            }, {
              t({
                " ",
                "<!-- markdownlint-disable -->",
                "<!-- prettier-ignore-start -->",
                " ",
                "<!-- tip=green, info=blue, warning=yellow, danger=red -->",
                " ",
                "> ",
              }),
              i(1),
              t({
                "",
                "{: .prompt-",
              }),
              -- In case you want to add a default value "tip" here, but I'm having
              -- issues with autosave
              -- i(2, "tip"),
              i(2),
              t({
                " }",
                " ",
                "<!-- prettier-ignore-end -->",
                "<!-- markdownlint-restore -->",
              }),
            })
          )

          table.insert(
            snippets,
            s({
              trig = "markdownlint",
              name = "Add markdownlint disable and restore headings",
              desc = "Add markdownlint disable and restore headings",
            }, {
              t({
                " ",
                "<!-- markdownlint-disable -->",
                " ",
                "> ",
              }),
              i(1),
              t({
                " ",
                " ",
                "<!-- markdownlint-restore -->",
              }),
            })
          )

          table.insert(
            snippets,
            s({
              trig = "prettierignore",
              name = "Add prettier ignore start and end headings",
              desc = "Add prettier ignore start and end headings",
            }, {
              t({
                " ",
                "<!-- prettier-ignore-start -->",
                " ",
                "> ",
              }),
              i(1),
              t({
                " ",
                " ",
                "<!-- prettier-ignore-end -->",
              }),
            })
          )

          table.insert(
            snippets,
            s({
              trig = "linkt",
              name = 'Add this -> [](){:target="_blank"}',
              desc = 'Add this -> [](){:target="_blank"}',
            }, {
              t("["),
              i(1),
              t("]("),
              i(2),
              t('){:target="_blank"}'),
            })
          )

          table.insert(
            snippets,
            s({
              trig = "todo",
              name = "Add TODO: item",
              desc = "Add TODO: item",
            }, {
              t("<!-- TODO: "),
              i(1),
              t(" -->"),
            })
          )

          -- Paste clipboard contents in link section, move cursor to ()
          table.insert(
            snippets,
            s({
              trig = "linkclip",
              name = "Paste clipboard as .md link",
              desc = "Paste clipboard as .md link",
            }, {
              t("["),
              i(1),
              t("]("),
              f(clipboard, {}),
              t(")"),
            })
          )

          ls.add_snippets("markdown", snippets)

          return opts
        end,
      },
      "rafamadriz/friendly-snippets",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      sources = {
        default = { "luasnip", "lsp", "path", "snippets", "buffer", "codecompanion", "copilot" },
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      keymap = { preset = "super-tab" },
      completion = {
        menu = {
          draw = {
            columns = { { "kind_icon", "label", gap = 1 }, { "kind" } },
          },
        },
      },
      vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#212136", fg = "#cdd6f4" }),
      vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1e1e2e", fg = "#585b70" }),
      vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#212136", fg = "#cdd6f4" }),
      vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#1e1e2e", fg = "#585b70" }),
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
        kind_icons = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Codeium = "󰘦 ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "  ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = "  ",
          File = " ",
          Folder = "  ",
          Function = "󰊕 ",
          Interface = " ",
          Key = " ",
          Keyword = " ",
          Method = " ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = " ",
          String = " ",
          Struct = "  ",
          TabNine = "󰏚 ",
          Text = " ",
          TypeParameter = " ",
          Unit = " ",
          Value = " ",
          Variable = " ",
        },
      },
    },
  },
}
