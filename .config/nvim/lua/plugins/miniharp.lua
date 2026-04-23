vim.pack.add({
  {
    src = 'https://github.com/vieitesss/miniharp.nvim',
    version = vim.version.range("v*"), -- latest stable release
    -- version = 'nightly', -- latest changes from main
  }
})

require('miniharp').setup({
  autoload = true, -- load marks for this cwd on startup (default: true)
  autosave = true, -- save marks for this cwd on exit (default: true)
  show_on_autoload = false, -- show popup list after a successful autoload (default: false)
  ui = {
    position = 'center', -- 'center' | 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right'
    show_hints = true, -- show close hints in the floating list (default: true)
    enter = true, -- enter the floating window when it opens (default: true)
  },
})
