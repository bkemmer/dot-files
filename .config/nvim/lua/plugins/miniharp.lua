vim.pack.add({
  {
    src = 'https://github.com/vieitesss/miniharp.nvim',
    version = vim.version.range("v*"), -- latest stable release
    -- version = 'nightly', -- latest changes from main
  }
})

require('miniharp').setup({
  autoload = true,          -- load marks for this cwd on startup (default: true)
  autosave = true,          -- save marks for this cwd on exit (default: true)
  show_on_autoload = false, -- show popup list after a successful autoload (default: false)
  ui = {
    position = 'center',    -- 'center' | 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
    show_hints = true,      -- show close hints in the floating list (default: true)
    enter = true,           -- enter the floating window when it opens (default: true)
  },
})

local miniharp = require('miniharp')

vim.keymap.set('n', '<leader>mf', miniharp.toggle_file, { desc = 'miniharp: toggle file mark' })
vim.keymap.set('n', '<leader>ml', miniharp.show_list, { desc = 'miniharp: toggle marks list' })
vim.keymap.set('n', '<leader>mc', miniharp.clear, { desc = 'miniharp: clear marks' })
vim.keymap.set('n', '<C-n>', miniharp.next, { desc = 'miniharp: next file mark' })
vim.keymap.set('n', '<C-p>', miniharp.prev, { desc = 'miniharp: prev file mark' })

vim.keymap.set('n', '<leader>1', function() miniharp.go_to(1) end, { desc = 'miniharp: go to mark 1' })
vim.keymap.set('n', '<leader>2', function() miniharp.go_to(2) end, { desc = 'miniharp: go to mark 2' })
vim.keymap.set('n', '<leader>3', function() miniharp.go_to(3) end, { desc = 'miniharp: go to mark 3' })
vim.keymap.set('n', '<leader>4', function() miniharp.go_to(4) end, { desc = 'miniharp: go to mark 4' })
