local km = vim.keymap

-- [[ Basic Keymaps ]]

-- leader key to space (vim.g.mapleader itself is set in config/options.lua,
-- which must happen before any mapping is defined)
km.set("n", "<space>", "<Nop>", {silent = true})

-- save files
km.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save'})

-- Select all text
km.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- " 'Q' in normal mode enters Ex mode. You almost never want this.-
km.set("n", "Q", "<Nop>", {silent = true})

-- Alias to replace all to S
-- km.set("n", "S", ":%s///g<Left><Left><Left>", {desc = "Search /"})
-- km.set("v", "S", ":'<,'>s///g<Left><Left><Left>", {desc = "Search /"})

-- For substitute using : as separators
km.set("n", "<leader>;;", ":%s:::g<Left><Left><Left>", {desc = "Search :"})
km.set("v", "<leader>;;", ":'<,'>s:::g<Left><Left><Left>", {desc = "Search :"})
km.set("n", "<leader>;c", ":%s:::gc<Left><Left><Left><Left>", {desc = "Search : gc"})

-- In command-line mode ("c"), when you type ;\, it expands to \(\) with the cursor placed between the parentheses, letting you type your capture group content immediately.
km.set("c", [[;\]], [[\(\)<Left><Left>]], { desc = "Adds a group selection to the substitute command" })
km.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "No Highlight Search" })

-- Open current window in a new tab | Use <C-W><C-Q> to go back
km.set("n", "<Leader>wo", ":tab split<CR>")

-- Shortcut for :tabnew
km.set("n", "<C-t>", ":tabnew<Space>")

-- Move up and down centering the cursos in the middle of the screen
km.set("n", "<C-u>", "<C-u>zz")
km.set("n", "<C-d>", "<C-d>zz")

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: diagnostics are configured in config/lsp.lua (single global call).
-- NOTE: <leader>q is quit_if_no_named_buffer (config/exiting.lua).
-- For diagnostics use <leader>sd / <leader>sD (snacks pickers).

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
