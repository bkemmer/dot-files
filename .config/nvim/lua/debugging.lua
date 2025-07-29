
require("nvim-dap-virtual-text").setup()
require("dapui").setup()

-- Python
require("dap-python").setup("~/.virtualenvs/neovim/bin/python")
-- require('nvim-dap-repl-highlights').setup()

local dap = require("dap")

-- Lua
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- Breakpoints color
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint'})
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#993939' })
