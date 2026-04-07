require('config')

vim.pack.add({
        'https://github.com/folke/tokyonight.nvim',
        'https://github.com/rachartier/tiny-glimmer.nvim',
})
vim.cmd.colorscheme('tokyonight-storm')

require('plugins')
require('tiny-glimmer')
