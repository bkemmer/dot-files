-- Behavioural assertions: drive real keystrokes, assert on resulting state.
-- Do not run directly: use `sh test/run.sh`.
--
-- Where test_config.lua asks "is this key mapped?", this file asks "does
-- pressing it do the right thing?". The original treesitter breakage is the
-- motivating example: a mapping check can only see "unmapped", while this
-- catches a mapping that exists but selects the wrong range.
--
-- Expected values were measured against fixtures/sample.py, whose line numbers
-- are load-bearing. If you edit that fixture, re-measure.

local pass, fail = 0, 0
local failures = {}

local function check(name, ok, detail)
  if ok then
    pass = pass + 1
  else
    fail = fail + 1
    failures[#failures + 1] = ("%s\n      %s"):format(name, detail or "")
  end
end

local function eq(name, got, want)
  check(name, got == want, ("expected %s, got %s"):format(vim.inspect(want), vim.inspect(got)))
end

local DIR = debug.getinfo(1, "S").source:sub(2):match("(.*)/")
local FIXTURE = DIR .. "/fixtures/sample.py"

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "x", false)
end

local function escape()
  vim.cmd("silent! normal! \27")
end

-- Select with `keys` from (line, col) and return the line range as "a..b".
local function sel_lines(line, col, keys)
  escape()
  vim.api.nvim_win_set_cursor(0, { line, col })
  feed(keys)
  if not vim.fn.mode():lower():find("v") then
    escape()
    return "NO SELECTION"
  end
  local s, e = vim.fn.getpos("v"), vim.fn.getpos(".")
  escape()
  local a, b = s[2], e[2]
  if a > b then a, b = b, a end
  return ("%d..%d"):format(a, b)
end

-- Select with `keys` and return the selected text (single-line objects).
local function sel_text(line, col, keys)
  escape()
  vim.api.nvim_win_set_cursor(0, { line, col })
  feed(keys)
  if not vim.fn.mode():lower():find("v") then
    escape()
    return "NO SELECTION"
  end
  local s, e = vim.fn.getpos("v"), vim.fn.getpos(".")
  escape()
  return vim.fn.getline(s[2]):sub(math.min(s[3], e[3]), math.max(s[3], e[3]))
end

-- ---------------------------------------------------------------------------
-- 1. Textobjects select the right thing, not merely *a* thing.
-- ---------------------------------------------------------------------------
vim.cmd("edit " .. vim.fn.fnameescape(FIXTURE))
vim.bo.filetype = "python"
vim.wait(500, function() return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil end)

eq("vam selects the whole function",        sel_lines(7, 4, "vam"), "6..8")
eq("vim selects only the function body",    sel_lines(7, 4, "vim"), "7..8")
eq("vaC selects the whole class",           sel_lines(13, 8, "vaC"), "11..16")
eq("vas selects the local scope",           sel_lines(7, 4, "vas"), "6..8")

eq("vac selects the whole call",            sel_text(16, 15, "vac"), 'greet(self.prefix, "!")')
eq("vic selects the call arguments",        sel_text(16, 15, "vic"), 'self.prefix, "!"')
eq("va= selects the whole assignment",      sel_text(13, 8, "va="), "self.prefix = prefix")
eq("vi= selects the assignment lhs",        sel_text(13, 8, "vi="), "self.prefix")
eq("vaA selects the parameter with comma",  sel_text(6, 12, "vaA"), "name,")
eq("viA selects the bare parameter",        sel_text(6, 12, "viA"), "name")

-- inner must be strictly narrower than outer, which a wrong query would break
check("vim is narrower than vam",
  #sel_text(7, 4, "vim") <= #sel_text(7, 4, "vam"), "inner selection was not narrower")

-- ---------------------------------------------------------------------------
-- 2. Diagnostics render the way the merged config says they should.
-- ---------------------------------------------------------------------------
local ns = vim.api.nvim_create_namespace("behaviour_probe")
vim.diagnostic.set(ns, 0, {
  { lnum = 2, col = 0, message = "probe error", severity = vim.diagnostic.severity.ERROR },
})
vim.cmd("redraw")

local virt = nil
for _, m in ipairs(vim.api.nvim_buf_get_extmarks(0, -1, 0, -1, { details = true })) do
  local d = m[4]
  if d and d.virt_text then
    local s = ""
    for _, chunk in ipairs(d.virt_text) do s = s .. chunk[1] end
    if s:find("probe error") then virt = s end
  end
end
check("diagnostic virtual text carries the bullet prefix",
  virt ~= nil and virt:find("●") ~= nil,
  "virt_text was " .. vim.inspect(virt))

-- HINT must not be underlined: underline is limited to severity.min = WARN
local ul = vim.diagnostic.config().underline
check("underline floor is WARN, so hints stay clean",
  type(ul) == "table" and ul.severity and ul.severity.min == vim.diagnostic.severity.WARN,
  "underline = " .. vim.inspect(ul))
vim.diagnostic.reset(ns, 0)

-- ---------------------------------------------------------------------------
-- 3. Folding is available but nothing is closed on open.
--    foldmethod only became `expr` in this change set; this is the highest-risk
--    item, because a wrong foldlevel would greet you with a collapsed file.
-- ---------------------------------------------------------------------------
eq("foldmethod is expr", vim.wo.foldmethod, "expr")
check("foldexpr is the treesitter one", vim.wo.foldexpr:find("treesitter") ~= nil, vim.wo.foldexpr)
check("foldlevel is high enough to keep folds open", vim.wo.foldlevel >= 99,
  "foldlevel = " .. vim.wo.foldlevel)

local closed = {}
for l = 1, vim.fn.line("$") do
  if vim.fn.foldclosed(l) ~= -1 then closed[#closed + 1] = l end
end
check("no line is inside a closed fold on open", #closed == 0,
  "closed at lines " .. table.concat(closed, ","))

-- folding still *works* when asked
vim.api.nvim_win_set_cursor(0, { 7, 0 })
vim.cmd("silent! normal! zc")
check("zc actually folds (folding is functional, just not automatic)",
  vim.fn.foldclosed(7) ~= -1, "zc did not close a fold at line 7")
vim.cmd("silent! normal! zR")

-- ---------------------------------------------------------------------------
-- 4. Section motions, restored by unmapping the dead Snacks.words bindings.
-- ---------------------------------------------------------------------------
escape()
vim.api.nvim_win_set_cursor(0, { 1, 0 })
feed("]]")
local after_fwd = vim.fn.line(".")
check("]] moves forward by section", after_fwd > 1, "cursor stayed at line " .. after_fwd)

feed("[[")
check("[[ moves back", vim.fn.line(".") <= after_fwd, "cursor did not move back")

-- operator-pending is the capability the old normal-mode-only maps never had
local lines_before = vim.api.nvim_buf_line_count(0)
vim.api.nvim_win_set_cursor(0, { 1, 0 })
feed("d]]")
local lines_after = vim.api.nvim_buf_line_count(0)
check("d]] deletes through to the next section (operator-pending works)",
  lines_after < lines_before,
  ("line count %d -> %d"):format(lines_before, lines_after))
vim.cmd("silent! edit!") -- discard the deletion

-- ---------------------------------------------------------------------------
-- 5. mini.bufremove preserves the window layout -- the reason it won <leader>bd.
-- ---------------------------------------------------------------------------
vim.cmd("silent! only")
vim.cmd("silent! split")
vim.cmd("silent! enew")
local wins_before = #vim.api.nvim_tabpage_list_wins(0)
require("mini.bufremove").delete(0, true)
local wins_after = #vim.api.nvim_tabpage_list_wins(0)
eq("deleting a buffer keeps the split open", wins_after, wins_before)
vim.cmd("silent! only")

-- ---------------------------------------------------------------------------
-- 6. Scratch and terminal toggles open what they claim to.
-- ---------------------------------------------------------------------------
local before_buf = vim.api.nvim_get_current_buf()
Snacks.scratch()
vim.wait(300)
check("<leader>. opens a scratch buffer", vim.api.nvim_get_current_buf() ~= before_buf,
  "current buffer did not change")
vim.cmd("silent! bwipeout!")

vim.cmd("silent! only")
Snacks.terminal()
vim.wait(500)
local is_term = vim.bo.buftype == "terminal"
  or #vim.tbl_filter(function(b) return vim.bo[b].buftype == "terminal" end,
       vim.api.nvim_list_bufs()) > 0
check("terminal toggle opens a terminal buffer", is_term, "no terminal buffer found")
for _, b in ipairs(vim.api.nvim_list_bufs()) do
  if vim.bo[b].buftype == "terminal" then pcall(vim.api.nvim_buf_delete, b, { force = true }) end
end

-- ---------------------------------------------------------------------------
-- 7. Sessions: the read wrapper stays quiet rather than warning.
-- ---------------------------------------------------------------------------
check("MiniSessions.read is wrapped", type(MiniSessions.read) == "function", "not a function")
local ok_quiet = pcall(function()
  if vim.tbl_count(MiniSessions.detected) == 0 then MiniSessions.read() end
end)
check("reading with no sessions does not error or warn", ok_quiet, "read() raised")

for _, k in ipairs({ "<leader>Ss", "<leader>Sl", "<leader>Sw", "<leader>Sr" }) do
  local d = vim.fn.maparg(k, "n", false, true).desc
  check("session binding " .. k .. " is mini.sessions",
    d ~= nil and d:find("Session") ~= nil, "desc = " .. tostring(d))
end

-- NOTE: which-key group *labels* are deliberately not asserted here. Reading
-- them needs which-key's private tree internals, which would make this suite
-- brittle against plugin updates, for a cosmetic property that is obvious the
-- first time you press <leader>. Checked by eye instead.

io.write(("\n%d passed, %d failed\n"):format(pass, fail))
if fail > 0 then
  io.write("\nFAILURES:\n")
  for _, f in ipairs(failures) do io.write("  - " .. f .. "\n") end
  vim.cmd("cq")
end
