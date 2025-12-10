local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Window size persistence across sessions
local state_file = wezterm.home_dir .. '/.local/state/wezterm/window_size.json'

local function ensure_state_dir()
  local dir = wezterm.home_dir .. '/.local/state/wezterm'
  os.execute('mkdir -p "' .. dir .. '"')
end

local function load_window_size()
  local file = io.open(state_file, 'r')
  if file then
    local content = file:read('*a')
    file:close()
    local ok, state = pcall(wezterm.json_parse, content)
    if ok and state and state.cols and state.rows then
      return state.cols, state.rows
    end
  end
  return 120, 30  -- defaults
end

local function save_window_size(cols, rows)
  ensure_state_dir()
  local file = io.open(state_file, 'w')
  if file then
    file:write(wezterm.json_encode({ cols = cols, rows = rows }))
    file:close()
  end
end

-- Save window size on resize
wezterm.on('window-resized', function(window, pane)
  local dims = pane:get_dimensions()
  if dims.cols > 20 and dims.viewport_rows > 5 then
    save_window_size(dims.cols, dims.viewport_rows)
  end
end)

-- Load saved window size
local saved_cols, saved_rows = load_window_size()
config.initial_cols = saved_cols
config.initial_rows = saved_rows

-- Color scheme: Catppuccin Mocha
config.color_scheme = 'Catppuccin Mocha'

-- Disable tab bar (using Zellij for multiplexing)
config.enable_tab_bar = false

-- Window appearance - standard macOS title bar with traffic light buttons
config.window_decorations = 'TITLE | RESIZE'
config.window_background_opacity = 1.0

-- Font configuration
config.font_size = 14

-- Minimal window padding
config.window_padding = {
  left = '0.5cell',
  right = '0.5cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

-- Disable problematic default keybindings to avoid conflicts
-- with Zellij and Neovim opt+up/opt+down
config.keys = {
  -- Disable Wezterm's opt+up/down defaults (used by your Neovim)
  {
    key = 'UpArrow',
    mods = 'OPT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'DownArrow',
    mods = 'OPT',
    action = wezterm.action.DisableDefaultAssignment,
  },

  -- Disable common Zellij conflict keys
  {
    key = 'p',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'n',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'o',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'd',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'h',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },

  -- Keep essential shortcuts active
  {
    key = 'r',
    mods = 'SUPER',
    action = wezterm.action.ReloadConfiguration,
  },
  {
    key = 'q',
    mods = 'SUPER',
    action = wezterm.action.QuitApplication,
  },
}

-- Automatically reload config when file changes
config.automatically_reload_config = true

-- Reduce window close confirmation prompts
config.window_close_confirmation = 'NeverPrompt'

return config
