local spellcheck_filetypes = {
  "markdown",
  "text",
  "gitcommit",
  "plaintext",
}



local spellcheck_languages = { "en_us",  "pt_br" }

-- Default key mappings (can be customized by the user)
local key_mappings = {
  -- next_misspelled = "<leader>n",
  -- prev_misspelled = "<leader>p",
  -- correct_misspelled = "<leader>c",
  -- add_word = "<leader>a",
  -- mark_wrong = "<leader>d",
  toggle_spell = "<leader>ss",
  spellang_pt_br = "<leader>pt",
  spellang_en_us = "<leader>en_us",
}

-- Enable spellcheck for approved file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = spellcheck_filetypes,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = table.concat(spellcheck_languages, ",")

    -- -- Navigate misspellings
    -- vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.next_misspelled, ']s', { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.prev_misspelled, '[s', { noremap = true, silent = true })
    --
    -- -- Correct misspelling
    -- vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.correct_misspelled, 'z=', { noremap = true, silent = true })
    --
    -- -- Add word to spell file
    -- vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.add_word, 'zg', { noremap = true, silent = true })
    --
    -- -- Mark word as wrong
    -- vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.mark_wrong, 'zw', { noremap = true, silent = true })

    -- Toggle spell checking
    vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.toggle_spell, ':set spell!<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.spellang_pt_br, ':setlocal spell spelllang=pt_br<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', key_mappings.spellang_en_us, ':setlocal spell spelllang=en_us<CR>', { noremap = true, silent = true })
  end,
})

