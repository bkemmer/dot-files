-- Mini.deps is a minimal plugin manager for Neovim
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_packages = vim.fn.stdpath('data') .. '/site/'
local start_packages = path_packages .. 'pack/deps/start/'
local mini_path = start_packages .. 'mini.deps'

if not vim.loop.fs_stat(mini_path) then
  if manual_installs then
    local manual_installs_path = start_packages .. 'manual-installs.nvim'
    if vim.fn.isdirectory(manual_installs_path) ~= 0 then
      vim.cmd('packadd manual-installs.nvim')
      require('manual-installs').add({source = 'echasnovski/mini.nvim'})
    else
      print("Expected `manual-installs.nvim` to be installed in " .. manual_installs_path)
    end
  else
    vim.cmd('echo "Installing `mini.deps`" | redraw')
    local clone_cmd = {
      'git', 'clone', '--filter=blob:none',
      'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end
end

if manual_installs then
  MD = require('manual-installs')
else
  -- Set up 'mini.deps'
  MD = require('mini.deps')
  MD.setup({ path = { package = path_packages } })
end

return MD

