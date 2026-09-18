vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
require('mini.basics').setup()

-- mini.basics' `basic` mappings bind <C-s> to save in Normal, Insert and
-- Visual mode, which overwrites nvim 0.11's documented insert-mode default of
-- signature_help (:help i_CTRL-S). There is no per-key opt-out, so restore it
-- here for Insert only -- Normal and Visual keep saving, so <Esc><C-s> and
-- <leader>w both still work.
vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature help' })

-- DELIBERATE: mini.basics also takes `gO` (put blank line above), which nvim
-- otherwise maps to vim.lsp.buf.document_symbol(). Kept as mini's, because:
--   * help and :Man buffers map gO buffer-locally, and buffer-local beats
--     global, so their table-of-contents still works untouched;
--   * <leader>ss / <leader>sS already give LSP symbols through a snacks
--     picker with fuzzy search and preview, which beats the default.
-- Only the LSP outline is shadowed, and it is covered twice over. Not a bug.
require('mini.notify').setup()

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- `replace` would claim `gr`, but snacks binds that to LSP references and
-- loads later, so the operator was dead while `grr` (replace line) still
-- worked -- a leftover that looked functional. Disabled explicitly.
-- The other operators keep their prefixes: g= evaluate, gm multiply,
-- gs sort, gx exchange (mini moves the builtin gx to gX).
require('mini.operators').setup({ replace = { prefix = '' } })
require('mini.pairs').setup()
require('mini.bracketed').setup()
require('mini.extra').setup()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.visits').setup()
require('mini.diff').setup()
require('mini.comment').setup()
require('mini.bufremove').setup()
require('mini.trailspace').setup()
require('mini.cursorword').setup()
require('mini.move').setup()
require('mini.jump').setup()
require('mini.sessions').setup({
  autoread = true
})

-- mini's autoread calls MiniSessions.read() on VimEnter; read() echoes
-- "There are no detected sessions" in every directory that doesn't have one,
-- which is most of them. Keep autoread, drop the warning: gate only the
-- no-argument call. Reads with an explicit session name behave as before.
local mini_sessions_read = MiniSessions.read
MiniSessions.read = function(session_name, opts)
  if session_name == nil and vim.tbl_count(MiniSessions.detected) == 0 then return end
  return mini_sessions_read(session_name, opts)
end

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

-- tabline
require('mini.tabline').setup({
  -- show_icons = false,
})

-- wrapper for vim.notify
local opts = { ERROR = { duration = 10000 } }
vim.notify = require('mini.notify').make_notify(opts)
--
require('plugins.mini-configs.mini_hipatterns')
require('plugins.mini-configs.mini_keymaps')
require('plugins.mini-configs.mini_snippets')
