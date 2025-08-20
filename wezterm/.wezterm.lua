local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Nord (Gogh)'
config.font = wezterm.font('DankMono Nerd Font Mono', { weight = 'Bold' })
config.enable_tab_bar = false
config.audible_bell = 'Disabled'
config.animation_fps = 60
config.font_size = 18
config.line_height = 1.5
-- config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'
config.window_decorations = "RESIZE"

return config
