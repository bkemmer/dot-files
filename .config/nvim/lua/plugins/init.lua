-- Simples configurations
require('tiny-glimmer').setup()
require("gitsigns").setup()
require("fzf-lua").setup()

-- Using external configuration files
-- require("plugins.slime")
require("plugins.mini-configs")
require('plugins.py-lsp-config')

-- kaymaps for the plugins
require("plugins.plugins_keymaps")

-- display images
require("image").setup()
