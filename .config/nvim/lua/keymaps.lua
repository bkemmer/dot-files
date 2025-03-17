
local km = vim.keymap

-- leader key to space
km.set("n", "<space>", "<Nop>", {silent = true})
vim.g.mapleader = " "

-- save files
km.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})

-- Select all text
km.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- " 'Q' in normal mode enters Ex mode. You almost never want this.-
km.set("n", "Q", "<Nop>", {silent = true})

-- Alias to replace all to S
km.set("n", "S", ":%s//g<Left><Left>", {desc = "Search"})

-- Open current window in a new tab | Use <C-W><C-Q> to go back
km.set("n", "<Leader>wo", ":tab split<CR>")

-- Shortcut for :tabnew
km.set("n", "<C-t>", ":tabnew<Space>")

-- Preventing bad habits (in normal mode):
km.set("n", "<Left>", ":echoe 'Use h'<CR>")
km.set("n", "<Right", ":echoe 'Use l'<CR>")
km.set("n", "<Up>", ":echoe 'Use k'<CR>")
km.set("n", "<Down>", ":echoe 'Use j'<CR>")
-- Preventing bad habits (in insert mode):
km.set("n", "<Left>", ":echoe 'Use h'<CR>")
km.set("n", "<Right", ":echoe 'Use l'<CR>")
km.set("n", "<Up>", ":echoe 'Use k'<CR>")
km.set("n", "<Down>", ":echoe 'Use j'<CR>")

-- Use <C-[hjkl] to select the active split:
km.set("n", "<c-k>", ":wincmd k<CR>")
km.set("n", "<c-j>", ":wincmd j<CR>")
km.set("n", "<c-h>", ":wincmd h<CR>")
km.set("n", "<c-l>", ":wincmd l<CR>")

-- Creates a 'global' paste/yank from clipboard
km.set("n", "<Leader>p", '"+p')
km.set("n", "<Leader>y", '"+y')

-- Move up and down centering the cursos in the middle of the screen
km.set("n", "<C-u>", "<C-u>zz")
km.set("n", "<C-d>", "<C-d>zz")

  
