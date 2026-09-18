vim.pack.add({
        'https://github.com/folke/which-key.nvim',
})

local wk = require("which-key")
wk.setup({
	preset = "helix",
})
wk.add({
	{ "<leader>;", group = "substitute" },
	{ "<leader>j", group = "python repl" },
	{ "<leader>m", group = "miniharp marks" },
	{ "<leader>r", group = "review" },
	{ "<leader>t", group = "toggle" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>p", group = "plugins (vim.pack)" },
	{ "<leader>dp", group = "profiler" },
	{ "<leader>f", group = "file/find" },
	{ "<leader>g", group = "git" },
	{ "<leader>s", group = "search" },
	{ "<leader>S", group = "session" },
	{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
	{ "[", group = "prev" },
	{ "]", group = "next" },
	{ "g", group = "goto" },
	{ "gs", group = "surround" },
	{ "z", group = "fold" },
	{
		"<leader>b",
		group = "buffer",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{
		"<leader>w",
		group = "windows",
		proxy = "<c-w>",
		expand = function()
			return require("which-key.extras").expand.win()
		end,
	},
	-- better descriptions
	{ "gx", desc = "Open with system app" },
	{
		"<leader>fC",
		group = "Copy Path",
		{
			"<leader>fCf",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:p")) -- Copy full file path to clipboard
				vim.notify("Copied full file path: " .. vim.fn.expand("%:p"))
			end,
			desc = "Copy full file path",
		},
		{
			"<leader>fCn",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:t")) -- Copy file name to clipboard
				vim.notify("Copied file name: " .. vim.fn.expand("%:t"))
			end,
			desc = "Copy file name",
		},
		{
			"<leader>fCr",
			function()
				local cwd = vim.fn.getcwd() -- Current working directory
				local full_path = vim.fn.expand("%:p") -- Full file path
				local rel_path = full_path:sub(#cwd + 2) -- Remove cwd prefix and leading slash
				vim.fn.setreg("+", rel_path) -- Copy relative file path to clipboard
				vim.notify("Copied relative file path: " .. rel_path)
			end,
			desc = "Copy relative file path",
		},
	},
	-- NOTE: these two are siblings of the <leader>fC group, not members of it.
	-- Nested inside it they were silently never registered.
	{
		"<leader>?",
		function()
			require("which-key").show({ global = false })
		end,
		desc = "Buffer Keymaps (which-key)",
	},
	{
		"<c-w><space>",
		function()
			require("which-key").show({ keys = "<c-w>", loop = true })
		end,
		desc = "Window Hydra Mode (which-key)",
	},
	{
		-- Nested mappings are allowed and can be added in any order
		-- Most attributes can be inherited or overridden on any level
		-- There's no limit to the depth of nesting
		mode = { "n", "v" }, -- NORMAL and VISUAL mode
		{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	},
})
