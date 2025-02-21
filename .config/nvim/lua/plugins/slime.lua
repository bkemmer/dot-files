-- Neovim slime configuration in Lua
vim.g.slime_target = "tmux"
vim.g.slime_default_config = {
  socket_name = vim.fn.get(vim.fn.split(vim.env.TMUX, ","), 0),
  target_pane = ":.2"
}
