-- =============================================================================
-- lsp.lua — Language Server Protocol configuration
-- =============================================================================
-- LSP provides IDE features: autocompletion, go-to-definition, diagnostics,
-- refactoring, documentation, and much more.
--
-- Individual server configs live in the lsp/ directory:
--   lsp/lua_ls.lua  — Lua (for writing Neovim configs)
--   lsp/ruff.lua    — Python (fast linter and formatter)
--   lsp/ty.lua      — Python (type checker from Astral, pyright alternative)
--
-- rust-analyzer is connected via rustaceanvim (plugins.lua) — it integrates
-- better with cargo.
-- =============================================================================

-- Enable LSP servers. Neovim 0.11+ can read files from the lsp/ directory on its own.
-- Each server must be installed on the system (via Mason or manually).
vim.lsp.enable({
    "lua_ls", -- Lua Language Server (install: mason → lua-language-server)
    "ty",     -- Ty — type checker for Python by Astral
    "ruff",   -- Ruff — blazing-fast Python linter/formatter
})

-- Configure diagnostic display (errors, warnings, hints).
vim.diagnostic.config({
    -- Virtual text to the right of the code line.
    -- prefix "●" — marker before the error message.
    virtual_text = {
        prefix = "●",
    },
    -- Icons in the sign column (signcolumn) to the left of line numbers.
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ", -- red error icon
            [vim.diagnostic.severity.WARN]  = " ", -- yellow warning icon
            [vim.diagnostic.severity.INFO]  = " ", -- blue info icon
            [vim.diagnostic.severity.HINT]  = "󰌵 ", -- hint icon
        },
    },
    -- Underline problematic spots in the code.
    underline = true,
    -- Don't update diagnostics in insert mode — less flickering while typing.
    update_in_insert = false,
    -- Sort by severity: errors above warnings.
    severity_sort = true,
    -- Float window config for <leader>d (show diagnostic details).
    float = {
        border = "rounded", -- rounded border
        source = true,      -- show source (e.g. "ruff" or "lua_ls")
    },
})

-- Enable code lens globally.
-- Code lens — buttons/annotations above functions.
vim.lsp.codelens.enable(true)

-- Enable inlay hints — type hints displayed inline in the code.
vim.lsp.inlay_hint.enable(true)
-- vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6370", italic = true })
