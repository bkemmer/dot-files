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

	-- Project root detection via vim.fs.root.
	-- 0 — the buffer for which the LSP is being started.
	-- Walks up the directory tree until it finds .git/ or pyproject.toml.
	root_dir = vim.fs.root(0, { ".git/", "pyproject.toml", "requirements.txt"}),
}
