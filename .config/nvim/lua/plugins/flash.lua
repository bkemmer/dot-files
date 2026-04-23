vim.pack.add({
  "https://github.com/folke/flash.nvim",
})

require("flash")

-- JUMP
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })
-- Treesitter Search
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
-- Remote Actions
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Flash Remote" })
-- Treesitter Search
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
-- Search
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
