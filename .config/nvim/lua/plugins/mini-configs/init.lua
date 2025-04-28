require('mini.basics').setup()
require('mini.ai').setup()
require('mini.surround').setup()
require('mini.operators').setup()
require('mini.pick').setup()
require('mini.pairs').setup()
require('mini.completion').setup()
require('mini.bracketed').setup()
require('mini.extra').setup()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.visits').setup()
require('mini.diff').setup()
require('mini.comment').setup()
require('mini.bufremove').setup()
require('mini.trailspace').setup()
require('mini.cursorword').setup()
require('mini.move').setup()
require('mini.jump').setup()
require('mini.notify').setup()
require('mini.sessions').setup({
  autoread = true
})
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
require('plugins.mini-configs.mini_keymaps')
require('plugins.mini-configs.mini_snippets')
require('plugins.mini-configs.mini_pick')
