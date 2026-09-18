vim.pack.add({
  'https://github.com/rebelot/kanagawa.nvim',
})

require("kanagawa").load("dragon")

-- kitty takes its colours from kitty.conf (`include themes/kanagawa_dragon.conf`),
-- so nvim does not need to drive it. A previous ColorScheme autocmd shelled out
-- to `kitty +kitten themes` on every startup, which blocked while it wrote
-- ~/.config/kitty/current-theme.conf — a file kitty.conf does not include.
