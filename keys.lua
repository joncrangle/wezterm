local wezterm = require 'wezterm'

local act = wezterm.action
local M = {}

M.mod = wezterm.target_triple:find 'windows' and 'SHIFT|CTRL' or 'SHIFT|SUPER'
M.alt = wezterm.target_triple:find 'windows' and 'ALT' or 'SUPER'
M.super = wezterm.target_triple:find 'windows' and 'CTRL' or 'SUPER'

M.smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(act.SplitVertical { domain = 'CurrentPaneDomain' }, pane)
  else
    window:perform_action(act.SplitHorizontal { domain = 'CurrentPaneDomain' }, pane)
  end
end)

function M.setup(config)
  config.disable_default_key_bindings = true
  config.keys = {
    { mods = 'ALT', key = 'Enter', action = act.ToggleFullScreen },
    { mods = M.mod, key = 'm', action = act.Hide },
    { mods = 'SUPER', key = 'q', action = act.QuitApplication },
    { mods = 'SHIFT|CTRL', key = 'q', action = act.QuitApplication },
    -- Scrollback
    { mods = M.mod, key = 'k', action = act.ScrollByPage(-0.5) },
    { mods = M.mod, key = 'j', action = act.ScrollByPage(0.5) },
    -- Font Size
    { mods = M.super, key = '+', action = act.IncreaseFontSize },
    { mods = M.super, key = '-', action = act.DecreaseFontSize },
    { mods = M.super, key = '0', action = act.ResetFontSize },
    -- Tabs
    { mods = M.mod, key = 't', action = act.SpawnTab 'CurrentPaneDomain' },
    { mods = M.super, key = 't', action = act.SpawnTab 'CurrentPaneDomain' },
    { mods = M.mod, key = 'w', action = act.CloseCurrentTab { confirm = true } },
    { mods = M.super, key = 'w', action = act.CloseCurrentTab { confirm = true } },
    -- Move Tabs
    { mods = M.mod, key = '>', action = act.MoveTabRelative(1) },
    { mods = M.mod, key = '<', action = act.MoveTabRelative(-1) },
    -- Activate Tabs
    { mods = M.mod, key = 'l', action = act { ActivateTabRelative = 1 } },
    { mods = M.mod, key = 'h', action = act { ActivateTabRelative = -1 } },
    -- Splits
    { mods = M.mod, key = 'Enter', action = M.smart_split },
    { mods = M.mod, key = '|', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { mods = M.mod, key = '_', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { mods = M.alt, key = 'Backspace', action = act.CloseCurrentPane { confirm = true } },
    -- Activate Splits
    { mods = M.alt, key = 'h', action = act.ActivatePaneDirection 'Left' },
    { mods = M.alt, key = 'j', action = act.ActivatePaneDirection 'Down' },
    { mods = M.alt, key = 'k', action = act.ActivatePaneDirection 'Up' },
    { mods = M.alt, key = 'l', action = act.ActivatePaneDirection 'Right' },
    { mods = M.mod, key = 'R', action = wezterm.action.RotatePanes 'Clockwise' },
    -- Resize Splits
    { mods = M.alt, key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 3 } },
    { mods = M.alt, key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 3 } },
    { mods = M.alt, key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 3 } },
    { mods = M.alt, key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 3 } },
    { mods = M.alt, key = 'm', action = act.TogglePaneZoomState },
    -- show the pane selection mode, but have it swap the active and selected panes
    { mods = M.mod, key = 'S', action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },
    -- Clipboard
    { mods = M.mod, key = 'C', action = act.CopyTo 'Clipboard' },
    { mods = M.super, key = 'C', action = act.CopyTo 'Clipboard' },
    { mods = M.mod, key = 'Space', action = act.QuickSelect },
    { mods = M.mod, key = 'X', action = act.ActivateCopyMode },
    { mods = M.mod, key = 'f', action = act.Search 'CurrentSelectionOrEmptyString' },
    { mods = M.mod, key = 'V', action = act.PasteFrom 'Clipboard' },
    { mods = M.super, key = 'V', action = act.PasteFrom 'Clipboard' },
    { mods = M.mod, key = 'p', action = act.ActivateCommandPalette },
    { mods = M.mod, key = 'd', action = act.ShowDebugOverlay },
  }
  -- Select tab with SUPER + tab number
  for i = 1, 9 do
    table.insert(config.keys, { mods = M.super, key = tostring(i), action = act { ActivateTab = i - 1 } })
  end
end

return M
