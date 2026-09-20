vim.pack.add({"https://www.github.com/nvim-lua/plenary.nvim"})
vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})
vim.pack.add({
{
  src = "https://www.github.com/olimorris/codecompanion.nvim",
  version = vim.version.range("^19.0.0"),
  }
})


require("codecompanion").setup()
