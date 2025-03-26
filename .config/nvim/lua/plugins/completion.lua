-- require("friendly-snippets").setup()
-- will exclude all javascript snippets
require("blink.cmp").setup({
  fuzzy = {
    prebuilt_binaries = {
      download = false,
    },
  },
  snippets = { preset = 'mini_snippets' },
    -- ensure you have the `snippets` source (enabled by default)
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
})

