-- Not used 
-- local spellcheck_filetypes = {
--   "markdown",
--   "text",
--   "gitcommit",
--   "plaintext",
-- }

-- local spellcheck_languages = { "en_us",  "pt_br" }

vim.opt.spellfile = {
  vim.fn.expand("~/.config/nvim/spell/en.utf-8.add"),  -- English custom words
  vim.fn.expand("~/.config/nvim/spell/pt.utf-8.add"),  -- PT-BR custom words
}


vim.keymap.set('n', '<leader>st', ':set spell!<CR>', { desc = "Spellcheck Toggle", noremap = true, silent = true })
vim.keymap.set('n', '<leader>se', ':setlocal spell spelllang=en_us<CR>', { desc = "Spellcheck Lang EN_US", noremap = true, silent = true })
vim.keymap.set('n', '<leader>sP', ':setlocal spell spelllang=pt_br<CR>', { desc = "Spellcheck Lang PT_BR", noremap = true, silent = true })

-- Main default keymaps:
-- ]s: Next misspelled word.
-- [s: Previous misspelled word.
-- z=: Suggest corrections.
-- zg: Add word to dictionary.
