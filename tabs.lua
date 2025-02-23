-- Modified from https://github.com/folke/dot/blob/master/config/wezterm/tabs.lua
local wezterm = require 'wezterm' --[[@as Wezterm]]

local M = {}
M.arrow_solid = wezterm.nerdfonts.cod_triangle_right
M.arrow_thin = wezterm.nerdfonts.cod_chevron_right
M.icons = {
  ['air'] = wezterm.nerdfonts.md_language_go,
  ['apt'] = wezterm.nerdfonts.dev_debian,
  ['bacon'] = wezterm.nerdfonts.dev_rust,
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['bat'] = wezterm.nerdfonts.md_bat,
  ['btm'] = wezterm.nerdfonts.md_chart_donut_variant,
  ['btop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['btop4win++'] = wezterm.nerdfonts.md_chart_areaspline,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['chezmoi'] = wezterm.nerdfonts.md_home_plus_outline,
  ['cmd.exe'] = wezterm.nerdfonts.md_console_line,
  ['curl'] = wezterm.nerdfonts.md_flattr,
  ['debug'] = wezterm.nerdfonts.cod_debug,
  ['default'] = wezterm.nerdfonts.md_application,
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['dpkg'] = wezterm.nerdfonts.dev_debian,
  ['fish'] = wezterm.nerdfonts.md_fish,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['go'] = wezterm.nerdfonts.md_language_go,
  ['htop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['lazygit'] = wezterm.nerdfonts.cod_github,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['nix'] = wezterm.nerdfonts.linux_nixos,
  ['node'] = wezterm.nerdfonts.md_nodejs,
  ['npm'] = wezterm.nerdfonts.md_npm,
  ['nvim'] = wezterm.nerdfonts.custom_neovim,
  ['pacman'] = wezterm.nerdfonts.md_pac_man,
  ['paru'] = wezterm.nerdfonts.md_pac_man,
  ['pnpm'] = wezterm.nerdfonts.md_npm,
  ['postgresql'] = wezterm.nerdfonts.dev_postgresql,
  ['powershell.exe'] = wezterm.nerdfonts.md_console,
  ['psql'] = wezterm.nerdfonts.dev_postgresql,
  ['pwsh.exe'] = wezterm.nerdfonts.md_console,
  ['rpm'] = wezterm.nerdfonts.dev_redhat,
  ['redis'] = wezterm.nerdfonts.dev_redis,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
  ['rust'] = wezterm.nerdfonts.dev_rust,
  ['serial'] = wezterm.nerdfonts.md_serial_port,
  ['ssh'] = wezterm.nerdfonts.md_pipe,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['tls'] = wezterm.nerdfonts.md_power_socket,
  ['topgrade'] = wezterm.nerdfonts.md_rocket_launch,
  ['unix'] = wezterm.nerdfonts.md_bash,
  ['valkey'] = wezterm.nerdfonts.dev_redis,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['wget'] = wezterm.nerdfonts.md_arrow_down_box,
  ['yarn'] = wezterm.nerdfonts.seti_yarn,
  ['yay'] = wezterm.nerdfonts.md_pac_man,
  ['yum'] = wezterm.nerdfonts.dev_redhat,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
}

function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  ---@diagnostic disable-next-line: unused-local
  local process, other = title:match '^(%S+)%s*%-?%s*%s*(.*)$'
  local icon = M.icons[process]
  if not icon then
    icon = wezterm.nerdfonts.md_application
  end

  title = (icon and icon .. ' ' or '')

  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then
    title = wezterm.nerdfonts.fa_bars .. ' ' .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)
  return ' ' .. title .. ' '
end

function M.apply_to_config(config)
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true

  ---@diagnostic disable-next-line: redefined-local, unused-local
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = M.title(tab, max_width)
    local colors = config.resolved_palette
    local active_bg = colors.tab_bar.active_tab.bg_color
    local inactive_bg = colors.tab_bar.inactive_tab.bg_color
    local hover_bg = colors.tab_bar.new_tab_hover.bg_color
    local hover_fg = colors.tab_bar.new_tab_hover.fg_color

    local tab_idx = 1
    for i, t in ipairs(tabs) do
      if t.tab_id == tab.tab_id then
        tab_idx = i
        break
      end
    end
    local is_last = tab_idx == #tabs
    local next_tab = tabs[tab_idx + 1]
    local next_is_active = next_tab and next_tab.is_active
    local arrow = tab.is_active and M.arrow_solid or M.arrow_thin
    local arrow_bg = inactive_bg
    local arrow_fg = colors.tab_bar.inactive_tab_edge

    if is_last then
      arrow_fg = tab.is_active and active_bg or inactive_bg
      arrow_bg = colors.tab_bar.background
    elseif tab.is_active then
      arrow_bg = inactive_bg
      arrow_fg = active_bg
    elseif next_is_active then
      arrow_bg = active_bg
      arrow_fg = inactive_bg
    end

    local ret = {}

    if tab.is_active then
      table.insert(ret, { Attribute = { Intensity = 'Bold' } })
    end

    if hover then
      table.insert(ret, { Background = { Color = hover_bg } })
      table.insert(ret, { Foreground = { Color = hover_fg } })
    end

    table.insert(ret, { Text = ' ' })
    table.insert(ret, { Text = arrow })
    table.insert(ret, { Text = ' ' })
    table.insert(ret, { Text = tostring(tab_idx) })
    table.insert(ret, { Text = title })
    table.insert(ret, { Background = { Color = arrow_bg } })
    table.insert(ret, { Foreground = { Color = arrow_fg } })

    return ret
  end)

  ---@diagnostic disable-next-line: unused-local
  wezterm.on('update-status', function(window, pane)
    local colors = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']

    window:set_left_status(wezterm.format {
      { Foreground = { Color = colors.ansi[6] } },
      { Text = ' ' .. wezterm.nerdfonts.cod_terminal_tmux },
      { Attribute = { Italic = true } },
      { Text = ' ' .. window:active_workspace() },
      { Attribute = { Italic = false } },
      { Text = ' ' .. wezterm.nerdfonts.pl_left_soft_divider .. ' ' },
    })
  end)

  local event_listeners = {
    { event = 'resurrect.fuzzy_load', text = 'Resurrect ' .. wezterm.nerdfonts.md_sleep_off .. ' ' },
    { event = 'smart_workspace_switcher.workspace_switcher', text = 'Smart Workspace Switcher ' .. wezterm.nerdfonts.cod_terminal_tmux .. ' ' },
  }

  for _, v in ipairs(event_listeners) do
    wezterm.on(v.event .. '.start', function(window, _)
      local colors = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']

      window:set_right_status(wezterm.format {
        { Foreground = { Color = colors.ansi[5] } },
        { Text = v.text },
      })
    end)
    wezterm.on(v.event .. '.finished', function(window, _)
      window:set_right_status(wezterm.format {
        { Text = '' },
      })
    end)
  end
end

return M
