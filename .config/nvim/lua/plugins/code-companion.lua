vim.pack.add({"https://www.github.com/nvim-lua/plenary.nvim"})
vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})
vim.pack.add({
{
  src = "https://www.github.com/olimorris/codecompanion.nvim",
  version = vim.version.range("^19.0.0"),
  }
})


require("codecompanion").setup({
  adapters = {
    http = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          env = {
            api_key = "GITHUB_COPILOT_TOKEN",
          },
        })
      end,
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },
  })
