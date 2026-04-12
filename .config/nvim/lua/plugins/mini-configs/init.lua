vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
require('mini.basics').setup()
require('mini.notify').setup()

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

require('mini.operators').setup()
require('mini.pairs').setup()
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
require('mini.sessions').setup({
  autoread = true
})

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

-- tabline
require('mini.tabline').setup({
  -- show_icons = false,
})

-- wrapper for vim.notify
local opts = { ERROR = { duration = 10000 } }
vim.notify = require('mini.notify').make_notify(opts)
--
require('plugins.mini-configs.mini_hipatterns')
require('plugins.mini-configs.mini_keymaps')
require('plugins.mini-configs.mini_snippets')
