-- Simples configurations
require('tiny-glimmer').setup()
require("gitsigns").setup()
require("fzf-lua").setup()

-- Using external configuration files
-- require("plugins.slime")
require("plugins.mini-configs")


-- kaymaps for the plugins
require("plugins.plugins_keymaps")

-- local packer = require('packer')
-- -- require('packer').startup()
-- packer.startup(function(use)
--     use {
--   'nvim-lualine/lualine.nvim',
-- }
-- end)
