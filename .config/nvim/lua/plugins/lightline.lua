-- Neovim lightline configuration in Lua
vim.g.lightline = {
  tabline = { left = { { 'buffers' } }, right = { { 'close' } } },
  component_expand = { buffers = 'lightline#bufferline#buffers' },
  component_type = { buffers = 'tabsel' },
  colorscheme = 'onedark'
}
