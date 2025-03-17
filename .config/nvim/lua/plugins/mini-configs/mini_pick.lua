require('mini.pick').setup()

-- Mini.Pick Open()
vim.keymap.set("n", "<Leader>f", function() MiniPick.builtin.files() end, { desc = "Open Mini Pick for files" })
vim.keymap.set("n", "<Leader>g", function() MiniPick.builtin.files({ tool = 'git' }) end, { desc = "Open Mini Pick using git" })
vim.keymap.set("n", "<Leader>b", function() MiniPick.builtin.buffers() end, { desc = "Open Mini Pick for buffers" })
vim.keymap.set("n", "<Leader>l", function() MiniPick.builtin.grep_live() end, { desc = "Open Mini Pick grep files" })

