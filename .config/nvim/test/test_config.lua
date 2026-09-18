-- In-process assertions for this nvim config.
-- Do not run directly: use `sh test/run.sh`.
--
-- This file must be dofile()d from a scheduled callback in a normally started
-- nvim. `nvim -l` does not load plugins, and a `-c` command runs before
-- VimEnter, which is when which-key flushes its deferred mapping queue.

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

local function mapped(lhs, mode)
  local m = vim.fn.maparg(lhs, mode or "n", false, true)
  return m.desc or m.rhs or (m.callback and "<fn>") or nil
end

local function is_mapped(name, lhs, mode)
  local d = mapped(lhs, mode)
  check(name, d ~= nil, ("%s %s is UNMAPPED"):format(mode or "n", lhs))
end

local function not_mapped(name, lhs, mode)
  local d = mapped(lhs, mode)
  check(name, d == nil, ("%s %s should be free, got %q"):format(mode or "n", lhs, tostring(d)))
end

-- NOTE: which-key registers its mappings on a deferred queue that flushes
-- after VimEnter, so this file must be run from a scheduled callback, not
-- from a `-c` command (those execute before VimEnter). See the runner below.

-- 1. snacks toggles: were dead inside a `User VeryLazy` autocmd
for _, k in ipairs({ "<leader>us", "<leader>uw", "<leader>ud", "<leader>ul", "<leader>uL",
                     "<leader>uc", "<leader>uA", "<leader>uT", "<leader>ub", "<leader>uD",
                     "<leader>ua", "<leader>ug", "<leader>uS", "<leader>uz", "<leader>uZ",
                     "<leader>wm", "<leader>dpp", "<leader>dph" }) do
  is_mapped("snacks toggle " .. k, k)
end

-- 2. ruff scoped to python only (was `filetype`, a typo, so it matched every buffer)
check("ruff filetypes == {python}",
  vim.deep_equal(vim.lsp.config.ruff.filetypes, { "python" }),
  "got " .. vim.inspect(vim.lsp.config.ruff.filetypes))

-- 3. codecompanion: single setup() call, copilot adapter survives
local cc = require("codecompanion.config").config
for _, s in ipairs({ "chat", "inline", "agent" }) do
  check("codecompanion " .. s .. " adapter == copilot",
    cc.interactions[s] and cc.interactions[s].adapter == "copilot",
    "got " .. vim.inspect(cc.interactions[s] and cc.interactions[s].adapter))
end
check("codecompanion copilot adapter override intact",
  type(cc.adapters.http.copilot) == "function",
  "expected a function, got " .. type(cc.adapters.http.copilot))

-- 4. treesitter textobjects rewired for the `main` branch
for lhs, query in pairs({ ["am"] = "@function.outer", ["im"] = "@function.inner",
                          ["ac"] = "@call.outer",     ["ic"] = "@call.inner",
                          ["a="] = "@assignment.outer", ["i="] = "@assignment.inner",
                          ["aC"] = "@class.outer",    ["iC"] = "@class.inner",
                          ["aA"] = "@parameter.outer", ["iA"] = "@parameter.inner",
                          ["at"] = "@type",           ["as"] = "@local.scope" }) do
  local d = mapped(lhs, "o")
  check("textobject " .. lhs, d == query, ("expected %q, got %q"):format(query, tostring(d)))
end

-- 5. ty resolves its root per-buffer (was frozen at module load)
check("ty uses root_markers", vim.lsp.config.ty.root_markers ~= nil, "root_markers is nil")
check("ty has no frozen root_dir", vim.lsp.config.ty.root_dir == nil,
  "root_dir = " .. vim.inspect(vim.lsp.config.ty.root_dir))

-- 6. lua_ls targets the right runtime
check("lua_ls runtime == LuaJIT",
  vim.lsp.config.lua_ls.settings.Lua.runtime.version == "LuaJIT",
  "got " .. tostring(vim.lsp.config.lua_ls.settings.Lua.runtime.version))

-- 7. window nav restored, pyrepl moved off <C-j>
for _, k in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do is_mapped("window nav " .. k, k) end
check("<C-j> is window nav, not pyrepl",
  (mapped("<C-j>") or ""):lower():find("window") ~= nil,
  "got " .. tostring(mapped("<C-j>")))
is_mapped("pyrepl focus on <leader>jf", "<leader>jf")

-- 8. sessions moved clear of the snacks pickers
for _, k in ipairs({ "<leader>Ss", "<leader>Sl", "<leader>Sw", "<leader>Sr" }) do
  local d = mapped(k)
  check("session " .. k, d and d:find("Session") ~= nil, "got " .. tostring(d))
end

-- 9. mini.bufremove owns <leader>bd / bD; snacks keeps bo
check("<leader>bd is mini.bufremove", mapped("<leader>bd") == "delete buffer",
  "got " .. tostring(mapped("<leader>bd")))
is_mapped("<leader>bD force delete", "<leader>bD")
is_mapped("<leader>bo delete others", "<leader>bo")

-- 10. dap is reachable
for _, k in ipairs({ "<leader>db", "<leader>dB", "<leader>dc", "<leader>di",
                     "<leader>do", "<leader>dO", "<leader>dt", "<leader>dr",
                     "<leader>du", "<F5>", "<F10>", "<F11>", "<F12>" }) do
  is_mapped("dap " .. k, k)
end

-- 11. keys handed back to builtins / removed
not_mapped("]] restored to builtin", "]]")
not_mapped("[[ restored to builtin", "[[")
not_mapped("<leader>sp (lazy.nvim picker) gone", "<leader>sp")
not_mapped("<leader>fT (duplicate terminal) gone", "<leader>fT")
not_mapped("<c-:> (duplicate terminal) gone", "<c-:>")
not_mapped("<leader>S freed for sessions group", "<leader>S")

-- 12. survivors of the dedupe
check("<leader>n is the picker", mapped("<leader>n") ~= nil, "unmapped")
check("<leader>sb kept its description", mapped("<leader>sb") == "[S]earch [b]uffer Lines",
  "got " .. tostring(mapped("<leader>sb")))
check("<leader>ft label honest", mapped("<leader>ft") == "Terminal",
  "got " .. tostring(mapped("<leader>ft")))
is_mapped("<c-/> terminal", "<c-/>")
is_mapped("scratch select on <leader>.s", "<leader>.s")
is_mapped("scratch toggle on <leader>.", "<leader>.")

-- 13. substitute helpers kept their descriptions (dupes without desc removed)
check("<leader>;; described", mapped("<leader>;;") == "Search :", "got " .. tostring(mapped("<leader>;;")))
check("<leader>;c described", mapped("<leader>;c") == "Search : gc", "got " .. tostring(mapped("<leader>;c")))

-- 14. which-key entries that live on the deferred queue
is_mapped("<leader>? buffer keymaps", "<leader>?")
is_mapped("<c-w><space> hydra mode", "<c-w><space>")
for _, k in ipairs({ "<leader>fCf", "<leader>fCn", "<leader>fCr" }) do is_mapped("copy path " .. k, k) end

-- 15. review.nvim
check("Review command exists", vim.fn.exists(":Review") == 2, ":Review missing")
for _, k in ipairs({ "<leader>rr", "<leader>re", "<leader>rs", "<leader>rc", "<leader>rp" }) do
  is_mapped("review " .. k, k)
end

-- 16. diagnostics: one merged global config
local d = vim.diagnostic.config()
check("virtual_text has the dot prefix",
  type(d.virtual_text) == "table" and d.virtual_text.prefix ~= nil,
  "got " .. vim.inspect(d.virtual_text))
check("underline limited to WARN+",
  type(d.underline) == "table" and d.underline.severity.min == vim.diagnostic.severity.WARN,
  "got " .. vim.inspect(d.underline))
check("float source == if_many", d.float and d.float.source == "if_many",
  "got " .. vim.inspect(d.float))
check("signs configured", d.signs ~= nil, "signs is nil")

-- 17. blink configured at startup, not deferred to InsertEnter
check("blink.cmp configured eagerly",
  pcall(function() return require("blink.cmp").get_lsp_capabilities() end),
  "blink.cmp not set up")

-- 18. theme
check("colorscheme is kanagawa", vim.g.colors_name == "kanagawa", "got " .. tostring(vim.g.colors_name))
check("no kitty ColorScheme autocmd remains",
  #vim.tbl_filter(function(a) return a.pattern == "kanagawa" end,
    vim.api.nvim_get_autocmds({ event = "ColorScheme" })) == 0,
  "a ColorScheme autocmd with pattern 'kanagawa' is still registered")

-- 19. globals kept out of _G
check("QuitIfNoNamedBuffer is no longer global", _G.QuitIfNoNamedBuffer == nil, "still in _G")
is_mapped("<leader>q quit", "<leader>q")

-- 19b. The gr namespace: nvim 0.11's built-in LSP keys.
-- `gr` must stay a pure prefix -- a command there makes every press wait out
-- timeoutlen before the built-ins underneath it can resolve.
not_mapped("gr is a prefix only, so it does not wait on timeoutlen", "gr")
for _, k in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
  is_mapped("lsp builtin " .. k, k)
end
is_mapped("references picker on <leader>sr", "<leader>sr")
is_mapped("help picker on <leader>sh", "<leader>sh")

-- 19c. Labels this audit corrected. Each was wrong because nothing checked it.
check("gs is mini.operators sort, not surround",
  (mapped("gs") or ""):lower():find("sort") ~= nil,
  "gs = " .. tostring(mapped("gs")))
check("gx is mini.operators exchange",
  (mapped("gx") or ""):lower():find("exchange") ~= nil,
  "gx = " .. tostring(mapped("gx")))
check("gX is the system handler",
  (mapped("gX") or ""):lower():find("system handler") ~= nil,
  "gX = " .. tostring(mapped("gX")))
check("s is flash jump (mini.surround hangs off it)",
  (mapped("s") or ""):lower():find("flash") ~= nil,
  "s = " .. tostring(mapped("s")))
is_mapped("mini.surround add is reachable", "sa")
-- mini.operators replace is retired: it was shadowed by the references picker
check("mini.operators replace no longer claims gr",
  (mapped("grr") or ""):find("references") ~= nil,
  "grr = " .. tostring(mapped("grr")))
for _, k in ipairs({ "\\s", "\\w", "\\i", "\\h" }) do
  is_mapped("mini.basics toggle " .. k, k)
end

-- 19d. Insert-mode <C-s> is signature help, not save.
-- mini.basics' `basic` mappings claim <C-s> in Normal, Insert and Visual,
-- overwriting nvim's documented insert default (:help i_CTRL-S).
check("insert <C-s> is signature help",
  (vim.fn.maparg("<C-s>", "i", false, true).desc or ""):lower():find("signature") ~= nil,
  "i <C-s> = " .. tostring(vim.fn.maparg("<C-s>", "i", false, true).desc))
check("normal <C-s> still saves",
  (vim.fn.maparg("<C-s>", "n", false, true).desc or ""):lower():find("save") ~= nil,
  "n <C-s> = " .. tostring(vim.fn.maparg("<C-s>", "n", false, true).desc))

-- 20. folding actually engaged (foldexpr was inert under foldmethod=manual)
check("foldmethod == expr", vim.o.foldmethod == "expr", "got " .. vim.o.foldmethod)
check("foldexpr is treesitter", vim.o.foldexpr:find("treesitter") ~= nil, "got " .. vim.o.foldexpr)

io.write(("\n%d passed, %d failed\n"):format(pass, fail))
if fail > 0 then
  io.write("\nFAILURES:\n")
  for _, f in ipairs(failures) do io.write("  - " .. f .. "\n") end
  vim.cmd("cq")
end
