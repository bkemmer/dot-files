require('mini.pick').setup()

-- Mini.Pick Open()
vim.keymap.set("n", "<Leader>pf", function() MiniPick.builtin.files() end, { desc = "Open Mini Pick for files" })
vim.keymap.set("n", "<Leader>pg", function() MiniPick.builtin.files({ tool = 'git' }) end, { desc = "Open Mini Pick using git" })
vim.keymap.set("n", "<Leader>pb", function() MiniPick.builtin.buffers() end, { desc = "Open Mini Pick for buffers" })
vim.keymap.set("n", "<Leader>pr", function() MiniPick.builtin.grep_live() end, { desc = "Open Mini Pick ripgrep files" })
vim.keymap.set("n", "<Leader>pl", function() MiniPick.builtin.resume() end, { desc = "Restore previous picker" })

-- Mini.Extra
vim.keymap.set("n", "<Leader>ph", function() MiniExtra.pickers.visit_paths() end, { desc = "Open Mini Pick for visited paths ordered by robust frecency" })

