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
  keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  completion = {
    list = {
        selection = { preselect = false, auto_insert = true }
        },
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

