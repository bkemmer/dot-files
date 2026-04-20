vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
})

require("tokyonight").setup({
  style = "storm",
  on_highlights = function(hl, c)
    hl.LspInlayHint = {
      fg = "#a9b1d6", -- brighter foreground (adjust to taste)
      bg = "NONE",    -- or set to "NONE" for no background tint
      italic = true,  -- optional
    }
  end,
})
vim.cmd.colorscheme('tokyonight-storm')

