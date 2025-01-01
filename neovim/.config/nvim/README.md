<h3 align="center"><img src="https://readme-typing-svg.demolab.com/?lines=📜%20+My+Neovim+Configuration&font=Poppins"></h3>

## Table Of Contents
<!--toc:start-->
- [✨ Features Supported](#features-supported)
- [👀 Showcase](#👀-showcase)
- [⚡️ Requirements](#⚡️-requirements)
- [📁 File Structure](#📁-file-structure)
- [🚀 Getting Started](#🚀-getting-started)
- [📜 License](#📜-license)
- [👏 Credits](#👏-credits)
<!--toc:end-->
## ✨ Features Supported

- ⚡ The following languages and all other language support
  - ` Rust`
  - ` HTML`
  - ` Css`
  - `󱏿 Tailwind`
  - ` JavaScript`
  - `󰛦 TypeScript`
  - `󰢱 Lua`
- 📦 Linters and static analysis through [none-ls](https://github.com/nvimtools/none-ls.nvim) and [mason.nvim](https://github.com/williamboman/mason.nvim)
- 🥂 Lsp servers configured with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- 🧹 Autocompletion using the new [blink.cmp](https://github.com/saghen/blink.cmp)
- ⚒️  Testing using the fantastic [neotest](https://github.com/nvim-neotest/neotest) plugin
- ✴️  Treesitter syntax highlighting
- 💤 Easily customize and extend config
- 🎨 A theme switcher using [themery.nvim](https://github.com/zaldih/themery.nvim)
- 📷 Take code screenshots using [nvim-silicon](https://github.com/michaelrommel/nvim-silicon)
- 🚀 Blazingly fast using [💤 lazy.nvim](https://github.com/folke/lazy.nvim)

## 👀 Showcase

| ![Image 1](./images/buffer-neotree-markdown.png) | ![Image 2](./images/cmp-colorPicker.png) |
| ------------------------------------------------ | ---------------------------------------- |
| ![Image 3](./images/Dashboard.png)               | ![Image 4](./images/Telescope.png)       |

## 📁 File Structure

<details>

<summary> </summary>

```
    📂 ~/.config/nvim
    ├── 📂 lua
    │  └── 📂 config
    │  │   ├──  autocmds.lua
    │  │   ├──  keymaps.lua
    │  │   ├──  lazy.lua
    │  │   └──  options.lua
    │  └── 📂 plugins
    │      ├──  ai.lua
    │      ├──  annotations.lua
    │      ├──  auto-save.lua
    │      ├──  autopairs.lua
    │      ├──  autotag.lua
    │      ├──  bufferline.lua
    │      ├──  completions.lua
    │      ├──  cursor-highlight.lua
    │      ├──  dap.lua
    │      ├──  database.lua
    │      ├──  flash.lua
    │      ├──  formatting.lua
    │      ├──  git.lua
    │      ├──  grug-far.lua
    │      ├──  harpoon.lua
    │      ├──  icons.lua
    │      ├──  img-clip.lua
    │      ├──  indentation.lua
    │      ├──  lazydev.lua
    │      ├──  live-server.lua
    │      ├──  lsp.lua
    │      ├──  markdown.lua
    │      ├──  mdx.lua
    │      ├──  mini-ai.lua
    │      ├──  neogit.lua
    │      ├──  neotest.lua
    │      ├──  neotree.lua
    │      ├──  noice.lua
    │      ├──  nvchad.lua
    │      ├──  nvim-ui.lua
    │      ├──  persistance.lua
    │      ├──  rust.lua
    │      ├──  screenshots.lua
    │      ├──  snacks.lua
    │      ├──  snippets.lua
    │      ├──  statusline.lua
    │      ├──  tailwind.lua
    │      ├──  telescope.lua
    │      ├──  theme.lua
    │      ├──  todo-comments.lua
    │      ├──  treesitter.lua
    │      ├──  trouble.lua
    │      ├──  ts-comments.lua
    │      ├──  undotree.lua
    │      ├──  vim-tmux-navigation.lua
    │      ├──  which-key.lua
    │      └──  yanky.lua
    │
    ├──  init.lua
    ├──  lazy-lock.json
    ├── 󱕵 LICENSE
    └──  README.md
```

- The [lua/config](./lua/config/) directory contains all of neovims autocommands, keymaps, [lazy.nvim](https://github.com/folke/lazy.nvim) config, and options.
- The [lua/plugins](./lua/plugins/) directory contains all plugin specific configuration.
- The [lazy-lock.json](./lazy-lock.json) is lazy.nvim package managers lockfile.
- The [images](./images) directory contains the images that are showcased above.
- The [init.lua](./init.lua) file is the starting point for the neovim configuration.
- The [LICENSE](./LICENSE) file is the license for this folder.

</details>

## ⚡️ Requirements

- [Neovim](https://github.com/neovim/neovim) >= **0.9.0** (needs to be built with **LuaJIT**)
- [git](https://git-scm.com) >= **2.40.0** (Gitsigns)
- A [Nerd Font](https://www.nerdfonts.com/) (Important, Otherwise icons won't show.)
- [Silicon](https://github.com/Aloxaf/silicon) cli tool (Optional, see [screenshots.lua](./lua/plugins/screenshots.lua))

## 🚀 Getting Started

1. Clone this repository

```sh
git clone https://github.com/MuntasirSZN/dotfiles
```

2. If you have any configurations present, move it into backup.

```sh
mv ~/.config/nvim ~/.config/nvim.bak
```

3. Move The [nvim](../nvim) folder to `~/.config`

```sh
mv dotfiles/.config/nvim ~/.config
```

4. Open Neovim And Enjoy !

```sh
nvim
```

## 📜 License

This config is licensed under the [MIT license](./LICENSE). Feel free to use, do any pr or the way you want it.

## 👏 Credits

- Huge credits to [@folke](https://github.com/folke), his neovim distribution was my learning source. Link -> [💤Lazyvim](https://github.com/LazyVim/LazyVim)
- Also, huge credits to [@siduck](https://github.com/siduck), the creator of the amazing [Nvchad](https://github.com/NvChad/NvChad), his plugins and distribution is amazing, and my source of inspiration
- Big Shout Out to the creators of the various plugins which make neovim the editor we use today.
- Also, the people that actually made this editor.
