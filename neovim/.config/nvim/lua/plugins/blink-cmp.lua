local function pr_or_issue_configure_score_offset(items)
  -- Bonus to make sure items sorted as below:
  local keys = {
    -- place `kind_name` here
    { "openIssue", "openedIssue", "reopenedIssue" },
    { "openPR", "openedPR" },
    { "lockedIssue", "lockedPR" },
    { "completedIssue" },
    { "draftPR" },
    { "mergedPR" },
    { "closedPR", "closedIssue", "not_plannedIssue", "duplicateIssue" },
  }
  local bonus = 999999
  local bonus_score = {}
  for i = 1, #keys do
    for _, key in ipairs(keys[i]) do
      bonus_score[key] = bonus * (#keys - i)
    end
  end
  for i = 1, #items do
    local bonus_key = items[i].kind_name
    if bonus_score[bonus_key] then
      items[i].score_offset = bonus_score[bonus_key]
    end
    -- Sort by number when having the same bonus score
    local number = items[i].label:match("[#!](%d+)")
    if number then
      if items[i].score_offset == nil then
        items[i].score_offset = 0
      end
      items[i].score_offset = items[i].score_offset + tonumber(number)
    end
  end
end

return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "xzbdmw/colorful-menu.nvim",
      event = "InsertEnter",
      config = function()
        require("colorful-menu").setup({})
      end,
    },
    "mikavilpas/blink-ripgrep.nvim",
    "moyiz/blink-emoji.nvim",
    {
      "Kaiser-Yang/blink-cmp-git",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "archie-judd/blink-cmp-words" },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    sources = {
      compat = {},
      default = {
        "ripgrep",
        "git",
        "emoji",
        "dictionary",
        "thesaurus",
      },
      providers = {
        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
        },
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
        },
        lsp = {
          score_offset = 98,
          opts = {
            tailwind_color_icon = require("config.icons").misc.color_text,
          },
        },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          async = true,
          score_offset = 90,
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {},
        },
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          async = true,
          score_offset = 91,
          opts = { insert = true },
          should_show_items = function()
            return vim.tbl_contains({ "gitcommit", "markdown", "norg", "rmd", "org", "mdx" }, vim.o.filetype)
          end,
        },
        git = {
          module = "blink-cmp-git",
          name = "Git",
          async = true,
          score_offset = 92,
          enabled = function()
            return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
          end,
          ---@module "blink-cmp-git"
          ---@type blink-cmp-git.Options
          opts = {
            kind_icons = require("config.icons").blink_cmp_git,
            commit = {
              triggers = { ";" },
            },
            git_centers = {
              github = {
                issue = {
                  get_kind_name = function(item)
                    -- openIssue, reopenedIssue, completedIssue
                    -- not_plannedIssue, lockedIssue, duplicateIssue
                    return item.locked and "lockedIssue" or (item.state_reason or item.state) .. "Issue"
                  end,
                  configure_score_offset = pr_or_issue_configure_score_offset,
                },
                pull_request = {
                  get_kind_name = function(item)
                    -- openPR, closedPR, mergedPR, draftPR, lockedPR
                    return item.locked and "lockedPR"
                      or item.draft and "draftPR"
                      or item.merged_at and "mergedPR"
                      or item.state .. "PR"
                  end,
                  configure_score_offset = pr_or_issue_configure_score_offset,
                },
              },
            },
          },
        },
      },
    },
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
        "snippet_forward",
        "fallback",
      },
    },
    signature = { enabled = true },
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      list = {
        selection = {
          auto_insert = false,
        },
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        auto_show = true,
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            kind_icon = {
              text = function(ctx)
                local icons = require("config.icons").kinds
                local icon = (icons[ctx.kind] or "󰈚")

                return icon
              end,
            },
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    appearance = {
      nerd_font_variant = "normal",
    },
  },
  init = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    local blink_cmp_git_kind_name_highlight = {
      Commit = { default = false, fg = mocha.green },
      Mention = { default = false, fg = mocha.green },
      openPR = { default = false, fg = mocha.green },
      openedPR = { default = false, fg = mocha.green },
      closedPR = { default = false, fg = mocha.red },
      mergedPR = { default = false, fg = mocha.mauve },
      draftPR = { default = false, fg = mocha.overlay2 },
      lockedPR = { default = false, fg = mocha.pink },
      openIssue = { default = false, fg = mocha.green },
      openedIssue = { default = false, fg = mocha.green },
      reopenedIssue = { default = false, fg = mocha.green },
      completedIssue = { default = false, fg = mocha.mauve },
      closedIssue = { default = false, fg = mocha.mauve },
      not_plannedIssue = { default = false, fg = mocha.overlay2 },
      duplicateIssue = { default = false, fg = mocha.overlay2 },
      lockedIssue = { default = false, fg = mocha.pink },
    }
    for kind_name, hl in pairs(blink_cmp_git_kind_name_highlight) do
      vim.api.nvim_set_hl(0, "BlinkCmpGitKind" .. kind_name, hl)
      vim.api.nvim_set_hl(0, "BlinkCmpGitKindIcon" .. kind_name, hl)
      vim.api.nvim_set_hl(0, "BlinkCmpGitLabel" .. kind_name .. "Id", hl)
    end

    local blink_cmp_kind_name_highlight = {
      Emoji = { default = false, fg = mocha.peach },
      Ripgrep = { default = false, fg = mocha.surface2 },
    }

    for kind_name, hl in pairs(blink_cmp_kind_name_highlight) do
      vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind_name, hl)
    end
  end,
}
