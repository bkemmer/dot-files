vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/mfussenegger/nvim-dap-python",
})

local dap = require("dap")
--
dap.set_log_level("DEBUG")

require("dap-view").setup({
  winbar = {
    sections = { "scopes", "breakpoints", "threads", "repl" },
    default_section = "repl",
  },
  switchbuf = "uselast",
  auto_toggle = true,
})


require("dap-python").setup("python")
