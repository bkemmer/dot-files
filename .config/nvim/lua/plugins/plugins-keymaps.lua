-- [C]odeCompanion [P]rompt]
vim.keymap.set({ "n", "v" }, "<Leader>cp", function()
  return require("codecompanion").cli({ prompt = true })
end, { desc = "[C]odeCompanion [P]rompt" })
