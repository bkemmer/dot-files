
local km = vim.keymap
km.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- DAP (from LazyVim)
---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local dap = require("dap")

km.set('n', "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { silent = true, desc = "Debug: Breakpoint Condition" })
km.set('n', "<leader>db", function() dap.toggle_breakpoint() end, { silent = true, desc = "Debug: Toggle Breakpoint" })
km.set('n', "<leader>dc", function() dap.continue() end, { silent = true, desc = "Debug: Run/Continue" })
km.set('n', "<leader>da", function() dap.continue({ before = get_args }) end, { silent = true, desc = "Debug: Run with Args" })
km.set('n', "<leader>dC", function() dap.run_to_cursor() end, { silent = true, desc = "Debug: Run to Cursor" })
km.set('n', "<leader>dg", function() dap.goto_() end, { silent = true, desc = "Debug: Go to Line (No Execute)" })
km.set('n', "<leader>di", function() dap.step_into() end, { silent = true, desc = "Debug: Step Into" })
km.set('n', "<leader>dj", function() dap.down() end, { silent = true, desc = "Debug: Down" })
km.set('n', "<leader>dk", function() dap.up() end, { silent = true, desc = "Debug: Up" })
km.set('n', "<leader>drl", function() dap.run_last() end, { silent = true, desc = "Debug: Run Last" })
km.set('n', "<leader>dO", function() dap.step_out() end, { silent = true, desc = "Debug: Step Out" })
km.set('n', "<leader>do", function() dap.step_over() end, { silent = true, desc = "Debug: Step over" })
km.set('n', "<leader>dP", function() dap.pause() end, { silent = true, desc = "Debug: Pause" })
km.set('n', "<leader>dr", function() dap.repl.toggle() end, { silent = true, desc = "Debug: Toggle REPL" })
km.set('n', "<leader>ds", function() dap.session() end, { silent = true, desc = "Debug: Session" })
km.set('n', "<leader>dt", function() dap.terminate() end, { silent = true, desc = "Debug: Terminate" })
km.set('n', "<leader>dw", function() require("dap.ui.widgets").hover() end, { silent = true, desc = "Debug: Widgets" })
km.set('n', '<leader>df', function() local widgets = require"dap.ui.widgets"; widgets.centered_float(widgets.frames) end, 
  { silent = true, desc = "Debug: Widgets centered" })
-- OSV (lua debug)
vim.keymap.set('n', '<leader>dl', function() require"osv".launch({port = 8086}) end, { noremap = true , desc = "Debug: Lauch OSV (lua debug)"})
-- Dap view
-- vim.keymap.set("n", "<leader>dv", function() require("dap-view").toggle() end, { desc = "Debug: Toggle nvim-dap-view" })
-- Dap ui
