---@diagnostic disable-next-line: unused-local
local wezterm = require 'wezterm'

local M = {}

function M.setup(config)
  config.ssh_domains = {
    {
      name = 'tnas',
      remote_address = '192.168.1.165:9222',
      username = 'jonsuper',
      multiplexing = 'None',
    },
  }
end

return M

