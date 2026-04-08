-- =============================================================================
-- lsp/lua_ls.lua — Lua Language Server configuration
-- =============================================================================
-- Provides LSP support for Lua files, primarily for Neovim configs.
-- =============================================================================
return {
	cmd = { 'lua-language-server' }, -- server startup command
	filetypes = { 'lua' }, -- activate only for .lua files
	-- Project root markers: LSP searches for these files up the directory tree.
	-- When a file is found — its directory becomes the "project root".
	root_markers = {
		'.luarc.json',   -- lua-language-server config
		'.luarc.jsonc',  -- lua-language-server config (with comments)
		'.luacheckrc',   -- luacheck linter config
		'.stylua.toml',  -- stylua formatter config
		'stylua.toml',   -- stylua formatter config (without dot)
		'selene.toml',   -- selene linter config
		'selene.yml',    -- selene linter config (YAML)
		'.git',          -- git repository root
	},
	settings = {
		Lua = {
			runtime = {
				-- Lua version: Neovim uses LuaJIT (compatible with Lua 5.4).
				version = "Lua 5.4",
			},
			completion = {
				enable = true, -- enable autocomplete for Lua-specific APIs
			},
			diagnostics = {
				enable = true,
				-- Tell lua_ls that "vim" is a global variable (not an "undefined global" error).
				-- Without this, the entire init.lua would be red with "undefined global 'vim'" errors.
				globals = { "vim" },
			},
			workspace = {
				-- Add path to Neovim runtime files for API autocomplete.
				-- This enables hints for vim.api.*, vim.lsp.*, vim.opt.*, etc.
				library = { vim.env.VIMRUNTIME },
				-- Do not prompt to configure workspace for third-party libraries.
				-- Without this, lua_ls shows an annoying "configure your environment" popup.
				checkThirdParty = false,
			},
		},
	},
}
