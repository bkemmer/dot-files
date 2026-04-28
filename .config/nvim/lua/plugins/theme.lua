-- tokyonight
-- vim.pack.add({
--   'https://github.com/folke/tokyonight.nvim',
-- })

-- require("tokyonight").setup({
--   style = "storm",
--   on_highlights = function(hl, c)
--     hl.LspInlayHint = {
--       fg = "#a9b1d6", -- brighter foreground (adjust to taste)
--       bg = "NONE",    -- or set to "NONE" for no background tint
--       italic = true,  -- optional
--     }
--   end,
-- })
-- vim.cmd.colorscheme('tokyonight-storm')
--

-- kintsugi
-- vim.pack.add({
--   'https://github.com/metalelf0/kintsugi-nvim',
-- })
-- require("kintsugi").setup({
--       variant = "dark",        -- "dark" | "flared"
--       transparent = false,
--       terminal_colors = true,
--       bold_keywords = true,
--       italic_comments = false,
--     })
--
-- vim.cmd.colorscheme("kintsugi-dark")
--

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "kanagawa",
    callback = function()
        if vim.o.background == "light" then
            vim.fn.system("kitty +kitten themes Kanagawa_light")
        elseif vim.o.background == "dark" then
            vim.fn.system("kitty +kitten themes Kanagawa_dragon")
        else
            vim.fn.system("kitty +kitten themes Kanagawa")
        end
    end,
})
vim.pack.add({
  'https://github.com/rebelot/kanagawa.nvim',
})
require("kanagawa").load("dragon")


