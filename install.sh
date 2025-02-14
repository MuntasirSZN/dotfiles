#!/bin/sh

set -o errexit
set -o pipefail

printf " Enter the directory to install dotfiles (default: $HOME/.dotfiles): "
read -r USER_INPUT
DOTFILES_DIR="${USER_INPUT:-$HOME/.dotfiles}"
REPO_URL="https://github.com/MuntasirSZN/dotfiles.git"

# Check if dotfiles directory exists
if [ -d "$DOTFILES_DIR" ]; then
	echo " Dotfiles already installed in $DOTFILES_DIR"
	printf " Do you want to reinstall? (y/n): "
	read -r REINSTALL
	if [ "$REINSTALL" = "y" ]; then
		echo " Removing existing dotfiles..."
		rm -rf "$DOTFILES_DIR"
	else
		echo " Exiting..."
		exit 0
	fi
fi

# Clone dotfiles repository if not already present
if [ ! -d "$DOTFILES_DIR/.git" ]; then
	echo " Cloning dotfiles repository..."
	git clone --recursive "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

echo " Installing Stow..."

# Detect and install stow based on package manager
if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install -y stow
elif command -v brew >/dev/null 2>&1; then
	brew install stow
elif command -v pacman >/dev/null 2>&1; then
	sudo pacman -S --noconfirm stow
elif command -v dnf >/dev/null 2>&1; then
	sudo dnf install -y stow
elif command -v zypper >/dev/null 2>&1; then
	sudo zypper install -y stow
elif command -v nix-env >/dev/null 2>&1; then
	nix-env -i stow
elif [ -n "$WINDIR" ]; then
	echo " Error: Windows is not supported (but wsl is). Please install Stow In WSL."
	exit 1
else
	echo " Error: No suitable package manager found. Please install Stow manually."
	exit 1
fi

echo " Running Stow to install dotfiles..."

# Stow all folders in the dotfiles directory
stow */

if [ $? -eq 0 ]; then
	echo " Dotfiles installed successfully."
	rm install.sh
else
	echo " Dotfiles installation failed. Ensure dependencies are installed."
	rm install.sh
	exit 1
fi
