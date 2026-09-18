vim.pack.add({
  "https://github.com/vuki656/review.nvim",
})

require("review").setup()

vim.keymap.set("n", "<leader>rr", "<cmd>Review<cr>", { desc = "Review: toggle UI" })
vim.keymap.set("n", "<leader>re", "<cmd>Review export<cr>", { desc = "Review: export comments" })
vim.keymap.set("n", "<leader>rs", "<cmd>Review send<cr>", { desc = "Review: send to pane" })
vim.keymap.set("n", "<leader>rc", "<cmd>Review qc<cr>", { desc = "Review: quick comment" })
vim.keymap.set("n", "<leader>rp", "<cmd>Review qp<cr>", { desc = "Review: quick comment panel" })
