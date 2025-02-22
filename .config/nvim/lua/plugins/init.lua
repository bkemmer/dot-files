-- Simples configurations
require('tiny-glimmer').setup()
require("nvim-autopairs").setup()
require("gitsigns").setup()
require("fzf-lua").setup()

-- Using external configuration files
require("plugins.nvim_tree")
require("plugins.lightline")
require("plugins.slime")




-- kaymaps for the plugins
require("plugins.plugins_keymaps")
