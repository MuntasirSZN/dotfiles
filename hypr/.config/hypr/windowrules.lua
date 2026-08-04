hl.window_rule({ match = { class = "^(org\\.wezfurlong\\.wezterm)$" }, tile = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12, opacity = 0.9 })
hl.window_rule({ match = { class = "^(gnome-control-center)$" }, tile = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, tile = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, tile = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(gnome-calculator)$" }, float = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(galculator)$" }, float = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true, opacity = 0.9 })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Nautilus)$" }, float = true, opacity = 0.8 })
hl.window_rule({ match = { class = "^(xdg-desktop-portal)$" }, float = true, opacity = 0.9 })
-- Named rules for special cases
hl.window_rule({
	name = "Whatsapp-zapzap",
	match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" },
	size = "60% 70%",
	center = true,
})

hl.window_rule({
	name = "Picture-in-Picture",
	match = { title = "^(Picture-in-Picture)$" },
	float = true,
	move = "72% 7%",
	opacity = "0.95 0.75",
	pin = true,
	keep_aspect_ratio = true,
	size = "30% 30%",
})

hl.window_rule({
	name = "Thunar-Progress-bar",
	match = { class = "^(thunar)$", title = "^(File Operation Progress)$" },
	float = true,
	center = true,
	size = "26% 18%",
})

-- Browser tags mapping
hl.window_rule({
	match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" },
	tag = "browser",
})
hl.window_rule({ match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, tag = "browser" })
hl.window_rule({ match = { class = "^(chrome-.+-Default)$" }, tag = "browser" })
hl.window_rule({ match = { class = "^([Cc]hromium)$" }, tag = "browser" })
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" }, tag = "browser" })
hl.window_rule({ match = { class = "^(Brave-browser(-beta|-dev|-unstable)?)$" }, tag = "browser" })
hl.window_rule({ match = { class = "^([Tt]horium-browser|[Cc]achy-browser)$" }, tag = "browser" })
hl.window_rule({ match = { class = "^(zen-alpha|zen|zen-beta)$" }, tag = "browser" })

-- Terminal tags mapping
hl.window_rule({ match = { class = "^(Alacritty|kitty|kitty-dropterm|com.mitchellh.ghostty)$" }, tag = "terminal" })

-- Email tags mapping
hl.window_rule({ match = { class = "^([Tt]hunderbird|org.mozilla.Thunderbird)$" }, tag = "email" })
hl.window_rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, tag = "email" })
hl.window_rule({ match = { class = "^(org.gnome.Evolution)$" }, tag = "email" })

-- Project tags mapping
hl.window_rule({ match = { class = "^(codium|codium-url-handler|VSCodium)$" }, tag = "projects" })
hl.window_rule({ match = { class = "^(VSCode|code|code-url-handler)$" }, tag = "projects" })
hl.window_rule({ match = { class = "^(jetbrains-.+)$" }, tag = "projects" })
hl.window_rule({ match = { class = "^(dev.zed.Zed|antigravity)$" }, tag = "projects" })

-- Screenshare tags mapping
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, tag = "screenshare" })

-- IM tags mapping
hl.window_rule({ match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" }, tag = "im" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, tag = "im" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux)$" }, tag = "im" })
hl.window_rule({ match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, tag = "im" })
hl.window_rule({ match = { class = "^(teams-for-linux)$" }, tag = "im" })
hl.window_rule({ match = { class = "^(im.riot.Riot|Element)$" }, tag = "im" })

-- Game tags mapping
hl.window_rule({ match = { class = "^(gamescope)$" }, tag = "games" })
hl.window_rule({ match = { class = "^(steam_app_\\d+)$" }, tag = "games" })

-- Gamestore tags mapping
hl.window_rule({ match = { class = "^([Ss]team)$" }, tag = "gamestore" })
hl.window_rule({ match = { title = "^([Ll]utris)$" }, tag = "gamestore" })
hl.window_rule({ match = { class = "^(com.heroicgameslauncher.hgl)$" }, tag = "gamestore" })

-- File manager tags mapping
hl.window_rule({ match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" }, tag = "file-manager" })
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, tag = "file-manager" })

-- Wallpaper tags mapping
hl.window_rule({ match = { class = "^([Ww]aytrogen)$" }, tag = "wallpaper" })

-- Multimedia tags mapping
hl.window_rule({ match = { class = "^([Aa]udacious)$" }, tag = "multimedia" })
hl.window_rule({ match = { class = "^([Ss]potify)$" }, tag = "multimedia" })

-- Multimedia video tags mapping
hl.window_rule({ match = { class = "^([Mm]pv|vlc)$" }, tag = "multimedia_video" })

-- Settings tags mapping
hl.window_rule({ match = { title = "^(ROG Control)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^(wihotspot(-gui)?)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^(gnome-disks|wihotspot(-gui)?)$" }, tag = "settings" })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, tag = "settings" })
hl.window_rule({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" }, tag = "settings" })
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	tag = "settings",
})
hl.window_rule({ match = { class = "^(qt5ct|qt6ct)$" }, tag = "settings" })
hl.window_rule({ match = { class = "(xdg-desktop-portal-gtk)" }, tag = "settings" })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^([Rr]ofi)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^(btrfs-assistant)$" }, tag = "settings" })
hl.window_rule({ match = { class = "^(timeshift-gtk)$" }, tag = "settings" })

-- Viewer tags mapping
hl.window_rule({
	match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" },
	tag = "viewer",
})
hl.window_rule({ match = { class = "^(evince)$" }, tag = "viewer" })
hl.window_rule({ match = { class = "^(eog|org.gnome.Loupe)$" }, tag = "viewer" })

-- Overrides
hl.window_rule({ match = { tag = "multimedia_video" }, no_blur = true })
hl.window_rule({ match = { tag = "multimedia_video" }, opacity = "1.0" })
hl.window_rule({ match = { tag = "multimedia" }, no_blur = true })
hl.window_rule({ match = { tag = "multimedia" }, opacity = "1.0" })

-- Position
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({
	match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
	center = true,
})
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, center = true })

-- Idle management
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { fullscreen = 1 }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(*)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { title = "^(*)$" }, idle_inhibit = "fullscreen" })

-- Float
hl.window_rule({ match = { tag = "wallpaper" }, float = true, center = true })
hl.window_rule({ match = { tag = "settings" }, float = true, center = true })
hl.window_rule({ match = { tag = "viewer" }, float = true, center = true })
hl.window_rule({ match = { class = "([Zz]oom|onedriver|onedriver-launcher)" }, float = true })
hl.window_rule({ match = { class = "(org.gnome.Calculator|qalculate-gtk)" }, float = true })
hl.window_rule({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, float = true })

-- Popups and dialogues
hl.window_rule({ match = { title = "^(Authentication Required)$" }, float = true, center = true })
hl.window_rule({
	match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" },
	float = true,
})
hl.window_rule({
	match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" },
	float = true,
})
hl.window_rule({ match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, float = true })
hl.window_rule({ match = { title = "^(Add Folder to Workspace)$" }, float = true, size = "70% 60%", center = true })
hl.window_rule({ match = { title = "^(Save As)$" }, float = true, size = "70% 60%", center = true })
hl.window_rule({ match = { initial_title = "(Open Files)" }, float = true, size = "70% 60%" })
hl.window_rule({ match = { title = "^(SDDM Background)$" }, float = true, center = true, size = "16% 12%" })
hl.window_rule({ match = { class = "^(yad)$" }, float = true, center = true, size = "20% 20%" })
hl.window_rule({ match = { class = "^(hyprland-donate-screen)$" }, float = true, center = true })

-- Opacity
hl.window_rule({ match = { tag = "browser" }, opacity = "0.9 0.9" })
hl.window_rule({ match = { tag = "projects" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { tag = "im" }, opacity = "0.94 0.86" })
hl.window_rule({ match = { tag = "multimedia" }, opacity = "0.94 0.86" })
hl.window_rule({ match = { tag = "file-manager" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { tag = "terminal" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { tag = "settings" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { tag = "viewer" }, opacity = "0.82 0.75" })
hl.window_rule({ match = { tag = "wallpaper" }, opacity = "0.9 0.7" })
hl.window_rule({ match = { class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, opacity = "0.8 0.7" })
hl.window_rule({ match = { class = "^(deluge)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { class = "^(seahorse)$" }, opacity = "0.9 0.8" })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, opacity = "0.95 0.75" })

-- Size
hl.window_rule({ match = { tag = "wallpaper" }, size = "70% 70%" })
hl.window_rule({ match = { tag = "settings" }, size = "70% 70%" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, size = "60% 70%" })

-- Blur & Fullscreen
hl.window_rule({ match = { tag = "games" }, no_blur = true, fullscreen = 0 })
hl.window_rule({ match = { tag = "games" }, fullscreen = 0 })

-- Focus Management
hl.window_rule({ match = { class = "^(jetbrains-*)" }, no_initial_focus = true })
hl.window_rule({ match = { title = "^(wind.*)$" }, no_initial_focus = true })
hl.window_rule({
	match = { class = "^(steam)$", title = "^(notificationtoasts)" },
	no_initial_focus = true,
	pin = true,
})
hl.window_rule({
	match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
	float = true,
})
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { title = "^(PineconeMC).*$" }, opacity = "0.9" })
hl.window_rule({ match = { class = "^discord$" }, opacity = 0.75 })
hl.layer_rule({ match = { namespace = "^vicinae" }, no_anim = true, blur = true, ignore_alpha = 0 })
