-- =============================================================================
-- lsp/ty.lua — Ty type checker configuration for Python
-- =============================================================================
-- Ty is a new Python type checker from the Astral team (authors of Ruff and uv).
-- An alternative to pyright and mypy. Written in Rust, works significantly faster.
--
-- Note: as of 2025, Ty is under active development (beta).
-- For stable projects you can use pyright instead of ty.
--
-- Installation: pip install ty  or  via Mason once support is available
-- =============================================================================

return {
	cmd = { "ty", "server" }, -- command to start LSP mode

	filetypes = { "python" }, -- activate only for .py files

	-- Project root markers: Neovim walks up the directory tree per-buffer until
	-- one of these is found. (A `root_dir = vim.fs.root(0, ...)` here would be
	-- evaluated once, when this file is read, and freeze the root to whatever
	-- buffer happened to exist at startup.)
	root_markers = { "pyproject.toml", "requirements.txt", ".git" },
}
