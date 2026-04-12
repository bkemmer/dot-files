require("vim._core.ui2").enable({})
vim.o.cmdheight = 0
-- vim.g.tiny_cmdline = {
--     width = { value = "70%" },
-- }
vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" })
require("tiny-cmdline").setup({
    on_reposition = require("tiny-cmdline").adapters.blink,
})
