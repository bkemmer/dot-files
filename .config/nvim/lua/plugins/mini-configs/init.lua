require('mini.basics').setup()
require('mini.ai').setup()
require('mini.surround').setup()
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.completion').setup()
require('mini.bracketed').setup()
require('mini.extra').setup()
require('mini.icons').setup()
require('mini.visits').setup()

-- replacing lualine
require('mini.statusline').setup({
  -- use_icons = false,
})

-- tabline
require('mini.tabline').setup({
  -- show_icons = false, 
})

require('plugins.mini-configs.mini_hipatterns')
require('plugins.mini-configs.mini_files')
require('plugins.mini-configs.mini_pick')
