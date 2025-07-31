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

local manual_installs = true

if manual_installs then
  MD = require('manual-installs')
else
  -- Set up 'mini.deps'
  MD = require('mini.deps')
  MD.setup({ path = { package = path_packages } })

end

MD.add({source = 'folke/flash.nvim'})

-- -- This is a hack to echo the repository zip link if it can't clone it
-- -- nvim --cmd "lua manual_installs=true"
-- -- Therefore, I am replacing the original plugs_install function
-- MiniDeps.plugs_install = function(plugs)
--   if manual_installs then
--     for k,v in pairs(plugs) do
--     local input = vim.fn.input('Enter something: ')
--       vim.notify(k .. ": " .. v)
--     end
--   else
--     return MiniDeps.plugs_install(plugs)
--   end
-- end


return MD

