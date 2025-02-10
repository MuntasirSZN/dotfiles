#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

# define your preferred text editor and terminal to use
editor=${EDITOR:-nvim}
tty=ghostty

configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"

menu() {
	printf "1. edit Env-variables\n"
	printf "2. edit Window-Rules\n"
	printf "3. edit Startup_Apps\n"
	printf "4. edit User-Keybinds\n"
	printf "5. edit Monitors\n"
	printf "6. edit Laptop-Keybinds\n"
	printf "7. edit User-Settings\n"
	printf "8. edit Workspace-Rules\n"
	printf "9. edit Default-Settings\n"
	printf "10. edit Default-Keybinds\n"
}

main() {
	choice=$(menu | rofi -i -dmenu -config ~/.config/rofi/config-compact.rasi | cut -d. -f1)
	case $choice in
	1)
		$tty -e $editor "$UserConfigs/ENVariables.conf"
		;;
	2)
		$tty -e $editor "$UserConfigs/WindowRules.conf"
		;;
	3)
		$tty -e $editor "$UserConfigs/Startup_Apps.conf"
		;;
	4)
		$tty -e $editor "$UserConfigs/UserKeybinds.conf"
		;;
	5)
		$tty -e $editor "$UserConfigs/Monitors.conf"
		;;
	6)
		$tty -e $editor "$UserConfigs/Laptops.conf"
		;;
	7)
		$tty -e $editor "$UserConfigs/UserSettings.conf"
		;;
	8)
		$tty -e $editor "$UserConfigs/WorkspaceRules.conf"
		;;
	9)
		$tty -e $editor "$configs/Settings.conf"
		;;
	10)
		$tty -e $editor "$configs/Keybinds.conf"
		;;
	*) ;;
	esac
}

main
