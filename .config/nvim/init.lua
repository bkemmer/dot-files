-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.load_netrwPlugin = 1

-- Show line numbers
vim.opt.number = true

-- Enable mouse in all modes
vim.opt.mouse = 'a'

-- Disable the default Vim startup message
vim.opt.shortmess = vim.opt.shortmess + { I = true }

-- Enable relative line numbering mode
vim.opt.relativenumber = true

-- This setting makes search case-insensitive when all caracters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- " Unbind some useless/annoying default key bindings.
-- nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.-

-- No need to show the mode since it's displayed in the statusline
vim.g.noshowmode = true

-- Disable the highlight of the previous search
-- vim.opt.hlsearch = false

-- Enable wrap lines
vim.opt.wrap = true
-- Preserve identation of 'virtual lines'
vim.opt.breakindent = true

-- Tabs size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true


-- Colormap
vim.cmd [[packadd onedark.vim]]
vim.cmd.colorscheme('onedark')

-- Load keymaps
require('keymaps')
