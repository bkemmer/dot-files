-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.load_netrwPlugin = 1

-- Show line numbers
vim.opt.number = true

-- Enable mouse in all modes
vim.opt.mouse = 'a'

-- Disable the default Vim startup message
vim.opt.shortmess = vim.opt.shortmess + { I = true }

-- Enable relative line numbering mode
vim.opt.relativenumber = true

-- This setting makes search case-insensitive when all caracters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No need to show the mode since it's displayed in the statusline
vim.g.noshowmode = true

-- Enable wrap lines
vim.opt.wrap = true
-- Preserve identation of 'virtual lines'
vim.opt.breakindent = true


-- Hightlight line cursor is on
vim.opt.cursorline = true 

-- Tabs size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0" -- remove extra info on folds
vim.opt.foldtext = "" -- the first line of the fold will be syntax highlighted, rather than all be one colour
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4 -- This limits how deeply code gets folded

-- Searching
vim.opt.wildmenu = true -- tab complete on command line
vim.opt.ignorecase = true -- case insensitive search...
vim.opt.smartcase = true -- unless I use caps
vim.opt.hlsearch = true -- highlight matching text

-- -- Clipboard for mac and linux (using tmux)
-- vim.g.clipboard = {
--   name = 'myClipboard',
--   copy = {
--     ['+'] = { 'tmux', 'load-buffer', '-' },
--     -- ['+'] = { 'pbcopy' }, -- test for macos later
--     ['*'] = { 'tmux', 'load-buffer', '-' },
--   },
--   paste = {
--     ['+'] = { 'tmux', 'save-buffer', '-' },
--     -- ['+'] = { 'pbpaste' }, -- test for macos later
--     ['*'] = { 'tmux', 'save-buffer', '-' },
--   },
--   cache_enabled = 1,
-- }
--


vim.opt.incsearch = true -- update results while I type

-- Default venv configuration
vim.g.python3_host_prog=vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
