-- leader key to space
vim.keymap.set("n", "<space>", "<Nop>", {silent = true})
vim.g.mapleader = " "

-- save files
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})

-- Select all text
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- " 'Q' in normal mode enters Ex mode. You almost never want this.-
vim.keymap.set("n", "Q", "<Nop>", {silent = true})

-- Alias to replace all to S
vim.keymap.set("n", "S", ":%s//g<Left><Left>", {desc = "Search"})

-- Open current window in a new tab | Use <C-W><C-Q> to go back
vim.keymap.set("n", "<Leader>wo", ":tab split<CR>")

-- Shortcut for :tabnew
vim.keymap.set("n", "<C-t>", ":tabnew<Space>")

-- Preventing bad habits (in normal mode):
vim.keymap.set("n", "<Left>", ":echoe 'Use h'<CR>")
vim.keymap.set("n", "<Right", ":echoe 'Use l'<CR>")
vim.keymap.set("n", "<Up>", ":echoe 'Use k'<CR>")
vim.keymap.set("n", "<Down>", ":echoe 'Use j'<CR>")
-- Preventing bad habits (in insert mode):
vim.keymap.set("n", "<Left>", ":echoe 'Use h'<CR>")
vim.keymap.set("n", "<Right", ":echoe 'Use l'<CR>")
vim.keymap.set("n", "<Up>", ":echoe 'Use k'<CR>")
vim.keymap.set("n", "<Down>", ":echoe 'Use j'<CR>")

-- Use <C-[hjkl] to select the active split:
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Creates a 'global' paste from clipboard
vim.keymap.set("n", "gp", '"+p')

-- Move up and down centering the cursos in the middle of the screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")


