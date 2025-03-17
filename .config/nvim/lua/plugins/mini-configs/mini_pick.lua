require('mini.pick').setup()

-- Mini.Pick Open()
vim.keymap.set("n", "<Leader>f", MiniPick.builtin.files({ tool = 'rg' }), { desc = "Open Mini Pick" })


