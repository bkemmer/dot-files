-- Mini.deps is a minimal plugin manager for Neovim
-- installs using git clone
local MiniDeps = require("config.mini_deps")
Add, Now, Later = MiniDeps.add, MiniDeps.now, MiniDeps.later

require("manual-installs")


-- Mini
Add({source = 'echasnovski/mini.nvim'})

-- Lsp
Add({source = 'neovim/nvim-lspconfig'})

-- Quickstart configs for Nvim LSP
Add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'master',
  -- Perform action after every checkout
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
Later(function() require'nvim-treesitter.configs'.setup{highlight={enable=true}} end)

-- Colormap
Add({source = "folke/tokyonight.nvim"})
Now(function() vim.cmd[[colorscheme tokyonight-storm]] end)

-- A tiny Neovim plugin that adds subtle animations to various operations.
Add({source = 'rachartier/tiny-glimmer.nvim'})
Later(function() require('tiny-glimmer').setup() end)

-- Copilot
Add({source = "zbirenbaum/copilot.lua"})

-- Blink
Add({
  source = "saghen/blink.cmp", depends = { "rafamadriz/friendly-snippets" },
  checkout = "v1.3.1",
})
-- Completion for Blink & Copilot
Add({source = "giuxtaposition/blink-cmp-copilot",
     depends = { "zbirenbaum/copilot.lua" },
     })

-- Dap / Debugging
Add({
  source = "rcarriga/nvim-dap-ui",
  depends = { "mfussenegger/nvim-dap",
              "nvim-neotest/nvim-nio",
              -- "LiadOz/nvim-dap-repl-highlights",
              "theHamsta/nvim-dap-virtual-text",
           }
})

-- Dap Adapters
Add({source = "mfussenegger/nvim-dap-python"})
Add({source = "jbyuki/one-small-step-for-vimkind"})

-- UndoTree
Add({source = "mbbill/undotree"})

-- Neotest - for testing
Add ({
  source = "nvim-neotest/neotest",
  depends = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
})
-- Adapters for neotest
Add({source = "nvim-neotest/neotest-python"})

-- Early Retirement
-- Send buffers into early retirement by automatically closing them after x minutes of inactivity.
Add({source = "chrisgrieser/nvim-early-retirement"})
Later(function() require("early-retirement").setup({}) end)

--DiffView
Add({source = "sindrets/diffview.nvim"})
Later(function() require('diffview').setup() end)

-- Vim tmux navigator
Add({source = "christoomey/vim-tmux-navigator"})

-- AutoSave
Add({source = "pocco81/auto-save.nvim"})
Later(function() require("auto-save").setup() end)

-- Molten
Add({
  source = "benlubas/molten-nvim",
  depends = {
    "3rd/image.nvim",
    "kiyoon/magick.nvim",
  },
})

-- Plenary
Add({source = 'nvim-lua/plenary.nvim'})

--
-- for i, value in ipairs(MiniDeps.get_session()) do
--   print(i)
--   for k, v in pairs(value) do
--     print(k, v)
--   end
--
-- end
