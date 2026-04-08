-- =============================================================================
-- lsp/ruff.lua — Ruff LSP configuration for Python
-- =============================================================================
-- Ruff is a blazing-fast Python linter and formatter written in Rust.
-- Replaces: flake8, pylint, isort, black, and dozens of other tools.
-- Hundreds of times faster than alternatives thanks to Rust.
--
-- Installation: pip install ruff  or  :MasonInstall ruff
-- Ruff config: pyproject.toml / ruff.toml / .ruff.toml in the project root
-- =============================================================================
return {
	cmd = { "ruff", "server" }, -- LSP server mode
	filetype = { "python" }, -- activate only for .py files
	-- Project root markers: LSP will search for these files up the directory tree.
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml" },
	-- Fixes position encoding mismatch between Neovim and Ruff.
	-- Neovim uses utf-8 by default, but many LSP servers (including Ruff)
	-- work with utf-16 positions (the LSP protocol standard).
	-- Without this, diagnostics may be offset and cursor positions incorrect.
	capabilities = { offsetEncoding = { "utf-16" } }
}
