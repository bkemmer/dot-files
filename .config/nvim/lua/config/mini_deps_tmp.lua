-- Mini.deps is a minimal plugin manager for Neovim
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
-- require"dap".toggle_breakpoint()
local path_packages = vim.fn.stdpath('data') .. '/site/'
local start_packages = path_packages .. 'pack/deps/start/'
local mini_path = start_packages .. 'mini.deps'
-- if not vim.loop.fs_stat(mini_path) then
local manual_installs = true
  -- Check if the command `nvim --cmd "lua manual_installs=true"` was used:
  if manual_installs then
    vim.cmd('echo "here1"')
    vim.cmd('echo "Installing `manual-installs`" | redraw')
    vim.fn.mkdir(start_packages, 'p')
    -- vim.cmd('echo "Now install manual installs in " .. start_packages | redraw')
    vim.fn.input("Press a key when finished...")
    vim.fn.system(start_packages .. 'manual-installs')
    vim.cmd('packadd manual-installs')

  end
--   else
--     vim.cmd('echo "Installing `mini.deps`" | redraw')
--     local clone_cmd = {
--       'git', 'clone', '--filter=blob:none',
--       'https://github.com/echasnovski/mini.nvim', mini_path
--     }
--     vim.fn.system(clone_cmd)
--     vim.cmd('packadd mini.nvim | helptags ALL')
--     vim.cmd('echo "Installed `mini.nvim`" | redraw')
--   end
-- end

if not manual_installs then

    -- vim.cmd('echo "here2"')
  -- MD = require('manual-installs')
-- else
  -- Set up 'mini.deps'
  MD = require('mini.deps')
  MD.setup({ path = { package = path_packages } })

end
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

