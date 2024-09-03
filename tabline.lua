local wezterm = require 'wezterm'

local M = {}

local icons = {
  ['bash'] = wezterm.nerdfonts.cod_terminal_bash,
  ['btm'] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ['btop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['btop4win++'] = wezterm.nerdfonts.md_chart_areaspline,
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['cmd.exe'] = wezterm.nerdfonts.md_console_line,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['debug'] = wezterm.nerdfonts.cod_debug,
  ['default'] = wezterm.nerdfonts.md_application,
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['fish'] = wezterm.nerdfonts.md_fish,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['htop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['lazygit'] = wezterm.nerdfonts.cod_github,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['node'] = wezterm.nerdfonts.mdi_hexagon,
  ['nvim'] = wezterm.nerdfonts.custom_neovim,
  ['pacman'] = wezterm.nerdfonts.md_pac_man,
  ['paru'] = wezterm.nerdfonts.md_pac_man,
  ['powershell.exe'] = wezterm.nerdfonts.md_console,
  ['psql'] = wezterm.nerdfonts.dev_postgresql,
  ['pwsh.exe'] = wezterm.nerdfonts.md_console,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
  ['ssh'] = wezterm.nerdfonts.md_ssh,
  ['sudo'] = wezterm.nerdfonts.fa_hashtag,
  ['topgrade'] = wezterm.nerdfonts.md_rocket_launch,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['wezterm'] = wezterm.nerdfonts.dev_terminal,
  ['wget'] = wezterm.nerdfonts.mdi_arrow_down_box,
  ['yay'] = wezterm.nerdfonts.md_pac_man,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
}

local function get_icon(str)
  for k, v in pairs(icons) do
    if str:lower():match("^" .. k) then
      return v
    end
  end
  return icons['default']
end

function M.tabline()
  local tabline = wezterm.plugin.require 'https://github.com/michaelbrusegard/tabline.wez'
  local colors = wezterm.get_builtin_color_schemes()['Catppuccin Mocha']

  tabline.setup({
    options = {
      icons_enabled = true,
      theme = 'Catppuccin Mocha',
      color_overrides = {
        tab = {
          active = { fg = colors.tab_bar.active_tab.bg_color, bg = colors.tab_bar.new_tab.bg_color },
        },
      },
      section_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
      component_separators = {
        left = wezterm.nerdfonts.pl_left_soft_divider,
        right = wezterm.nerdfonts.pl_right_soft_divider,
      },
      tab_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick,
        right = wezterm.nerdfonts.ple_left_half_circle_thick,
      },
    },
    sections = {
      tabline_a = { 'workspace' },
      tabline_b = { not wezterm.target_triple:find 'windows' and 'window' },
      tabline_c = { ' ' },
      tab_active = {
        {
          Text = wezterm.nerdfonts.cod_triangle_right,
        },
        -- {
        --   'zoomed',
        --   padding = { left = 1, right = 0 },
        -- },
        {
          'tab_index',
        },
        {
          'process',
          padding = { left = 0, right = 1 },
          fmt = function(str)
            return get_icon(str)
          end
        },
      },
      tab_inactive = {
        {
          Text = wezterm.nerdfonts.cod_chevron_right,
        },
        -- {
        --   'zoomed',
        --   padding = { left = 1, right = 0 },
        -- },
        {
          'tab_index',
        },
        {
          'process',
          padding = { left = 0, right = 1 },
          fmt = function(str)
            return get_icon(str)
          end
        },
      },
      tabline_x = {},
      tabline_y = {},
      tabline_z = {},
    },
    extensions = { 'resurrect', 'smart_workspace_switcher' },
  })
end

function M.apply_to_config(config)
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.tab_bar_at_bottom = true
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true
  config.use_fancy_tab_bar = false
end

return M
