-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("Agave Nerd Font Mono")
config.font_size = 14.0
config.window_background_opacity = 0.8
config.win32_system_backdrop = "Acrylic"

-- default shell
config.default_prog = { "pwsh.exe" }

config.disable_default_key_bindings = true
local act = wezterm.action
local dirs = { Left = "h", Down = "j", Up = "k", Right = "l" }
config.keys = {
	{ key = "p", mods = "CTRL|ALT", action = act.ActivateCommandPalette },
	{ key = "r", mods = "CTRL|SHIFT", action = "ReloadConfiguration" },
	{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "Enter", mods = "CTRL", action = act.SpawnWindow },
}

for direction, key in pairs(dirs) do
	-- Adjust pane size
	config.keys[#config.keys + 1] =
		{ key = key, mods = "CTRL|SHIFT|ALT", action = act.AdjustPaneSize({ direction, 5 }) }

	config.keys[#config.keys + 1] = { key = key, mods = "ALT", action = act.ActivatePaneDirection(direction) }

	config.keys[#config.keys + 1] = {
		key = key,
		mods = "CTRL|ALT",
		action = act.SplitPane({
			direction = direction,
			command = { domain = "CurrentPaneDomain" },
			size = { Percent = 50 },
		}),
	}
end

-- and finally, return the configuration to wezterm
return config
