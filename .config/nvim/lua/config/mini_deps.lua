-- Mini.deps is a minimal plugin manager for Neovim

-- local function get_zip_url_from_github(author_repo_name)
--     -- Check if input is in correct format
--     if type(author_repo_name) ~= "string" or not author_repo_name:match(".+/.+") then
--         error("Input must be in the format 'author/repo'")
--     end
--
--     -- Construct the ZIP URL
--     local zip_url = string.format("https://github.com/%s/archive/refs/heads/main.zip", author_repo_name)
--     return zip_url
-- end
--
--
-- -- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
--   print("manual_installs: ");print(manual_installs)
--
--   if manual_installs then
--     vim.cmd('echo "Manual install:"' .. get_zip_url_from_github('echasnovski/mini.nvim') .. '"')
--     -- vim.fn.system('xdg-open')
--   else
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
      'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  -- end
end



-- Set up 'mini.deps'
local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })

-- This is a hack to echo the repository zip link if it can't clone it
-- nvim --cmd "lua manual_installs=true"
-- Therefore, I am replacing the original plugs_install function
MiniDeps.plugs_install = function(plugs)
  if manual_installs then
    for k,v in pairs(plugs) do
    local input = vim.fn.input('Enter something: ')
      vim.notify(k .. ": " .. v)
    end
  else
    return MiniDeps.plugs_install(plugs)
  end
end

-- function(plugs)
--   -- Clone
--   local prepare = function(p)
--     if p.source == nil and #p.job.err == 0 then p.job.err = { 'SPECIFICATION HAS NO `source` TO INSTALL PLUGIN.' } end
--     p.job.command = H.git_cmd('clone', p.source or '', p.path)
--     p.job.exit_msg = string.format('Installed `%s`', p.name)
--   end
--   H.plugs_run_jobs(plugs, prepare)
--
--   -- Checkout
--   vim.tbl_map(function(p) p.job.cwd = p.path end, plugs)
--   H.plugs_checkout(plugs, { exec_hooks = false, all_helptags = true })
--
--   -- Show warnings and errors
--   H.plugs_show_job_notifications(plugs, 'installing plugin')
-- end
--

return MiniDeps

