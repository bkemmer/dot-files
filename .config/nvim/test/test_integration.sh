#!/bin/sh
# Integration checks that need real files and separate nvim instances.
# Invoked by run.sh; can also be run on its own.

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
CFG=$(CDPATH='' cd -- "$DIR/.." && pwd)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fails=0

ok()   { printf '  PASS  %s\n' "$1"; }
bad()  { printf '  FAIL  %s\n       %s\n' "$1" "$2"; fails=$((fails+1)); }

printf '\n1. ruff attaches to python but NOT to other filetypes (filetypes typo)\n'
printf 'x = 1\n' > "$TMP/t.lua"
printf 'import os\n' > "$TMP/t.py"
for ft in lua py; do
  clients=$(nvim --headless "$TMP/t.$ft" -c 'lua vim.defer_fn(function()
    local n = {} for _, c in ipairs(vim.lsp.get_clients({bufnr=0})) do n[#n+1] = c.name end
    table.sort(n); io.write(table.concat(n, ","))
    vim.cmd("qa!") end, 2500)' 2>/dev/null)
  case "$ft:$clients" in
    lua:*ruff*) bad "ruff must not attach to .lua" "got [$clients]" ;;
    lua:*)      ok  "lua buffer: [$clients]" ;;
    py:*ruff*)  ok  "python buffer: [$clients]" ;;
    py:*)       bad "ruff must attach to .py" "got [$clients]" ;;
  esac
done

printf '\n2. treesitter indentexpr survives the filetype plugin\n'
ie=$(nvim --headless "$TMP/t.py" -c 'lua io.write(vim.bo.indentexpr)' -c 'qa!' 2>/dev/null)
case "$ie" in
  *treesitter*) ok "indentexpr = $ie" ;;
  *)            bad "ftplugin overwrote indentexpr" "got '$ie'" ;;
esac

printf '\n3. ty resolves its project root per-buffer, not frozen at startup\n'
mkdir -p "$TMP/projA" "$TMP/projB"
( cd "$TMP/projA" && git init -q . && printf '[project]\nname="a"\n' > pyproject.toml && printf 'x=1\n' > m.py )
( cd "$TMP/projB" && git init -q . && printf '[project]\nname="b"\n' > pyproject.toml && printf 'y=2\n' > m.py )
rootB=$(cd "$TMP/projA" && nvim --headless "$TMP/projB/m.py" -c 'lua vim.defer_fn(function()
  for _, c in ipairs(vim.lsp.get_clients({bufnr=0})) do
    if c.name == "ty" then io.write(c.root_dir or "nil") end
  end
  vim.cmd("qa!") end, 2500)' 2>/dev/null)
case "$rootB" in
  *projB*) ok "ty root follows the buffer: $rootB" ;;
  *)       bad "ty root did not follow the buffer" "expected .../projB, got '$rootB'" ;;
esac

printf '\n4. session round-trip: autoread restores, and stays silent when absent\n'
mkdir -p "$TMP/sess" && cd "$TMP/sess"
printf 'alpha\n' > a.txt && printf 'beta\n' > b.txt
nvim --headless a.txt b.txt -c 'lua vim.defer_fn(function()
  MiniSessions.write("Session.vim", { force = true }); vim.cmd("qa!") end, 500)' >/dev/null 2>&1
restored=$(nvim --headless -c 'lua vim.defer_fn(function()
  local n = {} for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(b) == 1 then n[#n+1] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t") end
  end
  table.sort(n); io.write(table.concat(n, ","))
  vim.cmd("qa!") end, 900)' 2>/dev/null)
case "$restored" in
  *a.txt*b.txt*) ok "autoread restored: [$restored]" ;;
  *)             bad "autoread did not restore the session" "got [$restored]" ;;
esac

printf '\n5. mini.sessions no longer warns on startup\n'
# With no session present, startup must produce nothing at all: the old
# "There are no detected sessions" warning fired here on every launch.
out=$(cd "$TMP" && nvim --headless -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 900)' 2>&1)
[ -z "$out" ] && ok "silent where no session exists" \
               || bad "unexpected output where no session exists" "$out"

# With a session present, autoread loads it and autowrite saves it again on
# exit, which legitimately prints "Written session". Only the warning is a bug.
out=$(cd "$TMP/sess" && nvim --headless -c 'lua vim.defer_fn(function() vim.cmd("qa!") end, 900)' 2>&1)
case "$out" in
  *"no detected sessions"*) bad "warning still fires where a session exists" "$out" ;;
  *) ok "no warning where a session exists" ;;
esac

printf '\n6. opening a file does not get clobbered by autoread\n'
name=$(cd "$TMP/sess" && nvim --headless a.txt -c 'lua vim.defer_fn(function()
  io.write(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")); vim.cmd("qa!") end, 900)' 2>/dev/null)
[ "$name" = "a.txt" ] && ok "nvim a.txt stays on a.txt" || bad "autoread hijacked an explicit file arg" "landed on '$name'"

printf '\n7. signature help returns a real signature\n'
sig=$(nvim --headless "$CFG/test/fixtures/sample.py" -c 'lua vim.defer_fn(function()
  vim.api.nvim_win_set_cursor(0, { 19, 18 })
  local before = #vim.api.nvim_list_wins()
  vim.lsp.buf.signature_help()
  vim.wait(2500, function() return #vim.api.nvim_list_wins() > before end)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(w).relative ~= "" then
      io.write(table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(w), 0, -1, false), " "))
    end
  end
  vim.cmd("qa!") end, 3500)' 2>/dev/null)
case "$sig" in
  *"name, punctuation"*) ok "signature help float shows the parameters" ;;
  *)                     bad "no signature returned" "got '$sig'" ;;
esac

printf '\n8. no orphan plugins left in the lock file\n'
orphans=""
for p in $(grep -o '"[a-zA-Z0-9._-]*": {' "$CFG/nvim-pack-lock.json" | tr -d '": {'); do
  grep -rqi "${p%%.*}" "$CFG/lua" "$CFG/init.lua" 2>/dev/null || orphans="$orphans $p"
done
[ -z "$orphans" ] && ok "every locked plugin is referenced" || bad "unreferenced plugins in lock file" "$orphans"

printf '\n'
[ "$fails" -eq 0 ] && printf 'integration: all checks passed\n' || printf 'integration: %d FAILED\n' "$fails"
exit "$fails"
