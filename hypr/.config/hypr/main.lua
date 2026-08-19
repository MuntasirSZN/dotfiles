require("env")
require("windowrules")
require("animations")
require("config")
require("dms-theme-sync")

-- Dank Material Shell
require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd SSH_AUTH_SOCK")
end)
