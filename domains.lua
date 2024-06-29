---@diagnostic disable-next-line: unused-local
local wezterm = require 'wezterm'

local M = {}

function M.setup(config)
  config.ssh_domains = {
    {
      name = 'arch',
      remote_address = '192.168.5.211',
      username = 'jon',
    },
    {
      name = 'mac',
      remote_address = '192.168.5.120',
      username = 'jonathancrangle',
    },
    {
      name = 'tnas',
      remote_address = '192.168.5.143:9222',
      username = 'jonsuper',
      multiplexing = 'None',
    },
  }
end

return M
