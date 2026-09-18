vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/mfussenegger/nvim-dap-python",
})

local dap = require("dap")

require("dap-view").setup({
  winbar = {
    sections = { "scopes", "breakpoints", "threads", "repl" },
    default_section = "repl",
  },
  switchbuf = "uselast",
  auto_toggle = true,
})


require("dap-python").setup("python")

-- Breakpoints
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
    if cond and cond ~= "" then dap.set_breakpoint(cond) end
  end)
end, { desc = "Debug: conditional breakpoint" })

-- Run / step
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: continue / start" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: step out" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: terminate" })

-- UI
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: toggle REPL" })
vim.keymap.set("n", "<leader>du", "<cmd>DapViewToggle<cr>", { desc = "Debug: toggle dap-view" })

-- Conventional function keys, handy mid-session
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
