<h1 align="center">
  <img src="https://readme-typing-svg.demolab.com/?lines=👋+Welcome+To+My+Dotfiles!;&font=Poppins">
</h1>

This repository contains my personal dotfiles configuration managed using GNU Stow. It includes configurations for various tools and applications I commonly use on my Linux system.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Configuration Files](#configuration-files)
- [Advanced Installation](#advanced-installation)
- [Contributing](#contributing)
- [License](#license)

## Overview

This dotfiles repository is designed to be easily managed and deployed across multiple systems using GNU Stow. It contains configurations for shell environments, terminal multiplexers, text editors, window managers, and various other tools.

## Installation

Run the bash script to install the required packages and create symlinks for the configurations:

> [!Note]
> Check the script first before running it.

```sh
curl -s https://raw.githubusercontent.com/MuntasirSZN/dotfiles/main/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

### Configuration Files

The `.config` directory contains various files for different applications:

- ags (HyprPanel)
- anyrun
- bat
- fastfetch
- hypr
- hyprpanel
- kidex.ron
- kitty
- Kvantum
- nvim
- rofi
- starship.toml
- swaync
- wallust
- waybar
- wlogout
- yazi

Each subdirectory in `.config` represents a separate stow package.

## Advanced Installation

1. Clone the repository to your home directory:

```bash
git clone https://github.com/MuntasirSZN/dotfiles.git ~/.dotfiles
```

2. Navigate to the cloned repository:

```sh
cd ~/.dotfiles
```

3. Create symlinks for the desired configurations using stow:

```bash
stow */ # For All Configs
stow zsh # Individual
```

> [!Important]
> If you want to use my neovim configurations, then please read its [README.md](./neovim/.config/nvim/README.md)

Replace `package_name` with the desired package (e.g., `kitty`, `nvim`, etc.).

## Contributing

Contributions are welcome! Feel free to fork this repository and submit pull requests with improvements or additions.

## License

This dotfiles repository is released under the MIT License. See the [LICENSE](./LICENSE) file for more information.
