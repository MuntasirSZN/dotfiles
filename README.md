# Dotfiles Repository

This repository contains my personal dotfiles configuration managed using GNU Stow. It includes configurations for various tools and applications I commonly use on my Linux system.

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Configuration Files](#configuration-files)
- [Stow Packages](#stow-packages)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

This dotfiles repository is designed to be easily managed and deployed across multiple systems using GNU Stow. It contains configurations for shell environments, terminal multiplexers, text editors, window managers, and various other tools.

## Installation

To install GNU Stow, you can use your distribution's package manager. On most systems, you can install it with:

```bash
sudo apt-get install stow # Debian-based systems
sudo pacman -S stow # Arch-based systems
brew install stow # macOS (using Homebrew)
```


## Configuration Files

The repository contains the following configuration files:

- `.bashrc`: Bash shell configuration
- `.gitconfig`: Git configuration
- `.tmux.conf`: Tmux terminal multiplexer configuration
- `.vimrc`: Vim text editor configuration
- `.zshrc`: Zsh shell configuration

These files are located in the root directory of the repository.

## Stow Packages

The `.config` directory contains various stow packages for different applications:

- ags
- anyrun
- bat
- fastfetch
- hypr
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

## Usage

To use this dotfiles repository:

1. Clone the repository to your home directory:
```bash
git clone https://github.com/MuntasirSZN/dotfiles.git ~/.dotfiles
```

2. Navigate to the cloned repository:
```
cd ~/.dotfiles
```

3. Create symlinks for the desired configurations using stow:
```bash
stow . # For All Configs
stow .zshrc # Individual
stow .config # The .config folder
```

4. For `.config` packages, use:
```
stow .config/nvim # For Other Folders In .config
```

Replace `package_name` with the desired package (e.g., `kitty`, `nvim`, etc.).

## Contributing

Contributions are welcome! Feel free to fork this repository and submit pull requests with improvements or additions.

## License

This dotfiles repository is released under the MIT License. See the LICENSE file for details.