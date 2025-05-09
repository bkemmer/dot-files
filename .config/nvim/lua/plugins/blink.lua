-- It is recommended to disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in blink-cmp-copilot.
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require("blink.cmp").setup({
  -- if needed download from here: https://cmp.saghen.dev/configuration/fuzzy.html#prebuilt-binaries-default-on-a-release-tag
  -- fuzzy = {
  --   prebuilt_binaries = {
  --     download = true, -- false,
  --   },
  -- },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  snippets = { preset = 'mini_snippets' },
    -- ensure you have the `snippets` source (enabled by default)
    sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
            -- transform_items = function(_, items)
            --   local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            --   local kind_idx = #CompletionItemKind + 1
            --   CompletionItemKind[kind_idx] = "Copilot"
            --   for _, item in ipairs(items) do
            --     item.kind = kind_idx
            --   end
            --   return items
            -- end,
          },
        },
    },
    appearance = {
        -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
        kind_icons = {
          Copilot = "",
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',

          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',

          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',

          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',

          Keyword = '󰻾',
          Constant = '󰏿',

          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
        },
    },
})

