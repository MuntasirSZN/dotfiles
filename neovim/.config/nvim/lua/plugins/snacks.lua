return {
  "folke/snacks.nvim",
  priority = 5000,
  lazy = false,
  config = function()
    local cache = {
      ascii_art = nil,
      last_modified = nil,
    }

    local function get_file_mod_time(filepath)
      local stat = vim.loop.fs_stat(filepath)
      return stat and stat.mtime.sec or nil
    end

    local function header()
      local ascii_path = os.getenv("HOME") .. "/.config/nvim/lua/ascii.txt"
      local current_mod_time = get_file_mod_time(ascii_path)

      -- If cache is empty or file has changed, reload
      if cache.last_modified ~= current_mod_time then
        local command = (vim.uv.os_uname().sysname == "Windows") and "type " .. ascii_path
          or "/run/current-system/sw/bin/cat " .. ascii_path

        cache.ascii_art = vim.fn.system(command)
        cache.last_modified = current_mod_time
      end
      -- NOTE: Check for tmux environment, as if not tmux then
      -- the ASCII art will jump down, fix is to add a line of spaces at the end
      if vim.fn.exists("$TMUX") == 0 then
        cache.ascii_art = cache.ascii_art .. "\n                                                                     "
      end

      return cache.ascii_art
    end

    -- stylua: ignore
    ---@type snacks.Config
    local opts = {
      styles = {
        above_cursor = {
          backdrop = false,
          position = 'float',
          border = "rounded",
          title_pos = 'left',
          height = 1,
          noautocmd = true,
          relative = 'cursor',
          row = -3,
          col = 0,
          wo = {
            cursorline = false,
          },
          bo = {
            filetype = 'snacks_input',
            buftype = 'prompt',
          },
          --- buffer local variables
          b = {
            completion = false, -- disable blink completions in input
          },
          keys = {
            n_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'n', expr = true },
            i_esc = { '<esc>', { 'cmp_close', 'stopinsert' }, mode = 'i', expr = true },
            i_cr = { '<cr>', { 'cmp_accept', 'confirm' }, mode = 'i', expr = true },
            i_tab = { '<tab>', { 'cmp_select_next', 'cmp' }, mode = 'i', expr = true },
            i_ctrl_w = { '<c-w>', '<c-s-w>', mode = 'i', expr = true },
            i_up = { '<up>', { 'hist_up' }, mode = { 'i', 'n' } },
            i_down = { '<down>', { 'hist_down' }, mode = { 'i', 'n' } },
            q = 'cancel',
          },
        },
      },
      animate = { enabled = true },
      bigfile = { enabled = true },
      terminal = {},
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = false,
        },
      },
      indent = {
        enabled = true,
        scope = { treesitter = { enabled = true } },
      },
      scope = { enabled = true },
      input = {
        enabled = true,
        win = {
          style = 'above_cursor',
        },
      },
      notifier = {
        enabled = true,
        filter = function(msg)
          if msg.msg:match("clipboard:") then
            return false
          elseif msg.title == "noice.nvim" and msg.msg.match(msg.msg, "`vim.notify`*") then
            return false
          end
          return true
        end
      },
      scroll = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
      spell = { enabled = true },
      picker = {
        matcher = {
          frecency = true,
        },
        previewers = {
          diff = {
            builtin = false,
            cmd = { "delta" },
          },
        },
        layout = {
          layout = {
            {
              {
                border = "solid",
                height = 1,
                title = " {source} {live} ",
                title_pos = "center",
                win = "input"
              },
              {
                border = "solid",
                title = "  Results  ",
                title_pos = "center",
                win = "list"
              },
              box = "vertical"
            },
            {
              border = "rounded",
              title = "{preview:Preview}",
              title_pos = "center",
              width = 0.53,
              win = "preview"
            },
            backdrop = false,
            border = "none",
            box = "horizontal",
            height = 0.9,
            width = 0.9
          },
        },
        ui_select = true,
        enabled = true,
        prompt = "  ",
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":FindNvimFiles",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras", enabled = package.loaded.lazy ~=nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = header()
        },
      },
    }
    require("snacks").setup(opts)
    vim.api.nvim_create_user_command("FindNvimFiles", function()
      local picker = require("snacks.picker")
      picker.pick({
        source = "files",
        title = " Neovim Config",
        cwd = "~/.config/nvim", -- Set the directory to search in
        hidden = true, -- Show hidden files, useful in config directories
      })
    end, {})

    local map = vim.keymap.set

    if vim.fn.executable("lazygit") == 1 then
      map("n", "<leader>gg", function()
        Snacks.lazygit()
      end, { desc = "Lazygit (Root Dir)" })
      map("n", "<leader>gG", function()
        Snacks.lazygit()
      end, { desc = "Lazygit (cwd)" })
      map("n", "<leader>gf", function()
        Snacks.lazygit.log_file()
      end, { desc = "Lazygit Current File History" })
      map("n", "<leader>gl", function()
        Snacks.lazygit.log()
      end, { desc = "Lazygit Log" })
      map("n", "<leader>gL", function()
        Snacks.lazygit.log()
      end, { desc = "Lazygit Log (cwd)" })
      map({ "n", "x" }, "<leader>gY", function()
        Snacks.gitbrowse({
          open = function(url)
            vim.fn.setreg("+", url)
          end,
          notify = true,
        })
      end, { desc = "Git Browse (copy)" })
    end
  end,
}
