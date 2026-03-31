require('config')

vim.pack.add({
        'https://github.com/nvim-mini/mini.nvim',
        'https://github.com/folke/tokyonight.nvim',
        'https://github.com/rachartier/tiny-glimmer.nvim',
        'https://github.com/rafamadriz/friendly-snippets',
        'https://github.com/folke/snacks.nvim',
        'https://github.com/folke/which-key.nvim',
        'https://github.com/Vigemus/iron.nvim',
        -- '',
        -- '',
        -- '',
})
vim.pack.add({
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = 'v1'
  },
})

vim.cmd.colorscheme('tokyonight-storm')

require('plugins')
require('tiny-glimmer')
