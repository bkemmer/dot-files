-- Disable the tutor
vim.g.loaded_tutor_mode_plugin = 1
-- Install plugins using Mini.Deps
-- Also instanciates the globals Now, Later, Add
require("install_plugins")

Now(function() require('vim_configs') end)
Now(function() require('keymaps') end)
Later(function() require('plugins.blink') end)



require('lsp')
require('spellcheck')
require('folding')
require("debugging")
require("treesitter")
require("lsp")
require("exiting")

-- -- Simples configurations
Now(function() require('plugins.keymaps') end)
--
-- -- Using external configuration files
Later(function() require("plugins.mini-configs") end)
Later(function() require("plugins.image") end)
Later(function() require("plugins.molten-config") end)
Later(function() require("plugins.blink") end)
--
-- -- -- FIXME:
-- if init_debug then
--   require"osv".launch({port=8086, blocking=true})
-- end
Later(function() require("globals") end)
-- Add("folke/flash.nvim")
