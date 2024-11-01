#!/usr/bin/bash

rofi_clipboard() {
  rofi -i -dmenu -config "~/.config/rofi/config-clipboard.rasi"
}
export -f rofi_clipboard

env CM_LAUNCHER=rofi_clipboard CM_OUTPUT_CLIP=1 clipmenu | clipcopy
