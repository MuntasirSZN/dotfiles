<h1 align="center">
  <img src="https://readme-typing-svg.herokuapp.com/?lines=👋+Welcome+To+My+Dotfiles!;&font=Poppins">
</h1>

<h4 align="center">
  <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8&logo=homepage&labelColor=1E1E2E" alt="License">
  <img src="https://img.shields.io/github/issues/MuntasirSZN/dotfiles?colorA=363a4f&colorB=f5a97f&style=for-the-badge&logo=github&labelColor=1E1E2E" alt="GitHub issues">
  <img src="https://img.shields.io/github/stars/MuntasirSZN/dotfiles?style=for-the-badge&logo=andela&color=FFB686&logoColor=D9E0EE&labelColor=1E1E2E" alt="GitHub stars">
  <img src="https://img.shields.io/github/last-commit/MuntasirSZN/dotfiles?&style=for-the-badge&color=FFB1C8&logoColor=D9E0EE&labelColor=1E1E2E&logo=git" alt="Last commit">
  <img alt="Repo size" src="https://img.shields.io/github/languages/code-size/MuntasirSZN/dotfiles?style=for-the-badge&logo=data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA0NDggNTEyIj48IS0tIUZvbnQgQXdlc29tZSBGcmVlIDYuNy4yIGJ5IEBmb250YXdlc29tZSAtIGh0dHBzOi8vZm9udGF3ZXNvbWUuY29tIExpY2Vuc2UgLSBodHRwczovL2ZvbnRhd2Vzb21lLmNvbS9saWNlbnNlL2ZyZWUgQ29weXJpZ2h0IDIwMjUgRm9udGljb25zLCBJbmMuLS0%2BPHBhdGggc3Ryb2tlPSIjQ0JBNkY3IiBmaWxsPSIjQ0JBNkY3IiBkPSJNOTYgMEM0MyAwIDAgNDMgMCA5NkwwIDQxNmMwIDUzIDQzIDk2IDk2IDk2bDI4OCAwIDMyIDBjMTcuNyAwIDMyLTE0LjMgMzItMzJzLTE0LjMtMzItMzItMzJsMC02NGMxNy43IDAgMzItMTQuMyAzMi0zMmwwLTMyMGMwLTE3LjctMTQuMy0zMi0zMi0zMkwzODQgMCA5NiAwem0wIDM4NGwyNTYgMCAwIDY0TDk2IDQ0OGMtMTcuNyAwLTMyLTE0LjMtMzItMzJzMTQuMy0zMiAzMi0zMnptMzItMjQwYzAtOC44IDcuMi0xNiAxNi0xNmwxOTIgMGM4LjggMCAxNiA3LjIgMTYgMTZzLTcuMiAxNi0xNiAxNmwtMTkyIDBjLTguOCAwLTE2LTcuMi0xNi0xNnptMTYgNDhsMTkyIDBjOC44IDAgMTYgNy4yIDE2IDE2cy03LjIgMTYtMTYgMTZsLTE5MiAwYy04LjggMC0xNi03LjItMTYtMTZzNy4yLTE2IDE2LTE2eiIvPjwvc3ZnPg%3D%3D&logoColor=CBA6F7&labelColor=1e1e2e&color=B4BEFE">
</h4>

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
