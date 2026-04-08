local km = vim.keymap

-- [[ Basic Keymaps ]]

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

-- Move up and down centering the cursos in the middle of the screen
km.set("n", "<C-u>", "<C-u>zz")
km.set("n", "<C-d>", "<C-d>zz")

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- For substitute using : as separators
km.set("n", "<leader>;;", ":%s:::g<Left><Left><Left>")
km.set("n", "<leader>;c", ":%s:::gc<Left><Left><Left><Left>")
-- km.set("n", "<leader>;<backslash>", "\(\)<Left><Left>")

km.set("c", [[;\]], [[\(\)<Left><Left>]], { desc = "Adds a group selection to the substitute command" })
km.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "No Highlight Search" })

-- For running lua scripts
km.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Run current file" })
km.set("n", "<space>x", ":.lua<CR>", { desc = "Run current lua line" })
km.set("v", "<space>x", ":lua<CR>", { desc = "Run visually selected lua lines" })


-- Updates using vim.pack
vim.keymap.set("n", "<leader>pu", "<cmd>lua vim.pack.update()<CR>")

-- Toogle inlay_type_hints
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
