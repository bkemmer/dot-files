require('config')

vim.pack.add({
        'https://github.com/nvim-mini/mini.nvim',
        'https://github.com/folke/tokyonight.nvim',
        'https://github.com/rachartier/tiny-glimmer.nvim',
        'https://github.com/rafamadriz/friendly-snippets',
        'https://github.com/folke/snacks.nvim',
        'https://github.com/folke/which-key.nvim',
        "https://github.com/romus204/tree-sitter-manager.nvim",
        { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },
        { src = 'https://github.com/neovim/nvim-lspconfig' },
})
vim.cmd.colorscheme('tokyonight-storm')

require('plugins')
require('tiny-glimmer')
