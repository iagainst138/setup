-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Molokai'


-- fonts
-- config.font = wezterm.font('JetBrains Mono', {
config.font = wezterm.font('Monospace', {
    -- weight = 'Bold',
    -- italic = true,
})
config.font_size = 11.0


-- tabs
config.enable_tab_bar = false


-- padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
