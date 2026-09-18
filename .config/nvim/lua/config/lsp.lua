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
-- No namespace argument, so this is the GLOBAL default: it applies to every
-- filetype and every diagnostic producer, not just the servers enabled above.
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
    -- Text underneath the line rather than at the end of it. Off for now.
    virtual_lines = false,
    -- Underline problematic spots, but only WARN and above — underlining
    -- every hint leaves the whole buffer squiggly.
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    -- Don't update diagnostics in insert mode — less flickering while typing.
    update_in_insert = false,
    -- Sort by severity: errors above warnings.
    severity_sort = true,
    -- Float window config (show diagnostic details).
    float = {
        border = "rounded",  -- rounded border
        source = "if_many",  -- name the source only when several are attached
    },
    -- Auto-open the float when jumping with [d and ]d.
    jump = { float = true },
})

-- Enable code lens globally.
-- Code lens — buttons/annotations above functions.
vim.lsp.codelens.enable(true)

-- Enable inlay hints — type hints displayed inline in the code.
vim.lsp.inlay_hint.enable(true)
-- vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5c6370", italic = true })
