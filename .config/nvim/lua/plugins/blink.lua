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
  keymap = {
    preset = 'super-tab',
      ["<S-k>"] = { "scroll_documentation_up", "fallback" },
      ["<S-j>"] = { "scroll_documentation_down", "fallback" }
  },
  completion = {
  menu = {
    draw = {
      components = {
        kind_icon = {
          text = function(ctx)
            local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind) return kind_icon
          end,
          -- (optional) use highlights from mini.icons
          highlight = function(ctx)
            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
            return hl
          end,
        },
        kind = {
          -- (optional) use highlights from mini.icons
          highlight = function(ctx)
            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
            return hl
          end,
        }
      }
    }
  },
  trigger = {
    show_in_snippet = false,
  },
},
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
          },
        },
    },
})

