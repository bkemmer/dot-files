vim.pack.add({
  "https://github.com/dangooddd/pyrepl.nvim",
  -- "https://github.com/nvim-treesitter/nvim-treesitter",
}, {
  confirm = false,
  load = true,
})

local pyrepl = require("pyrepl")
local venv_python_path = '~/.venv_nvim/bin'
local python_path = vim.fn.isdirectory(venv_python_path) == 1 and vim.fs.joinpath(venv_python_path, "python") or "python"
-- default config
pyrepl.setup({
  split_horizontal = false,
  split_ratio = 0.5,
  style = "default",
  -- generate jupyter-console theme from neovim theme
  style_integration = true,
  image_max_history = 10,
  image_width_ratio = 0.5,
  image_height_ratio = 0.5,
  -- built-in provider, works best for ghostty and kitty
  -- for other terminals use "image" provider
  image_provider = "placeholders",
  -- can also be a function for advanced use cases
  cell_pattern = "^#.?%%.*$",
  python_path = python_path,
  preferred_kernel = "python3",
  -- automatically prompt to convert notebook files into python scripts
  jupytext_hook = true,
})

-- repl ui-related commands
vim.keymap.set("n", "<leader>jo", pyrepl.open_repl, {desc = 'Open REPL'})
vim.keymap.set("n", "<leader>jh", pyrepl.hide_repl, {desc = 'Hide REPL'})
vim.keymap.set("n", "<leader>jc", pyrepl.close_repl, {desc = 'Close REPL'})
vim.keymap.set("n", "<leader>jt", pyrepl.toggle_repl, {desc = 'Toogle REPL'})
vim.keymap.set("n", "<leader>ji", pyrepl.open_image_history, {desc = 'Open Image History'})
vim.keymap.set({ "n", "t" }, "<C-j>", pyrepl.toggle_repl_focus, {desc = 'Toogle REPL Focus'})

-- send commands
vim.keymap.set("n", "<leader>jb", pyrepl.send_buffer, {desc = 'Send Buffer to REPL'})
vim.keymap.set("n", "<leader>jr", pyrepl.send_cell, {desc = 'Send Cell to REPL'})
vim.keymap.set("v", "<leader>jv", pyrepl.send_visual, {desc = 'Send Visual'})

-- QoL commands
vim.keymap.set("n", "<leader>jp", pyrepl.step_cell_backward, {desc = 'Step Cell Backward'})
vim.keymap.set("n", "<leader>jn", pyrepl.step_cell_forward, {desc = 'Step Cell Forward'})
vim.keymap.set("n", "<leader>je", pyrepl.export_to_notebook, {desc = 'Step Cell Backward'})
vim.keymap.set("n", "<leader>js", ":PyreplInstall", {desc = 'PyrepInstall'})

vim.keymap.set("n", "<leader>jl", function()
  vim.cmd("PyreplSendCell")
  vim.cmd("PyreplStepCellForward")
end)
