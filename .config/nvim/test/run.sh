#!/bin/sh
# Verification suite for this nvim config.
#
#   sh .config/nvim/test/run.sh
#
# Exits non-zero if anything regressed. Run it before committing a config
# change or after `vim.pack.update()`.
#
# Why the scheduled callback: which-key registers its mappings on a deferred
# queue that flushes after VimEnter. A `-c` command runs *before* that, and
# reports healthy mappings as UNMAPPED. Every assertion must run from a
# scheduled callback, which is what the -c below sets up.

DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
status=0

printf '=== unit assertions ===\n'
nvim --headless -c "lua vim.defer_fn(function()
  local ok, err = pcall(dofile, '$DIR/test_config.lua')
  if not ok then io.write('SUITE ERROR: ' .. tostring(err) .. '\n'); vim.cmd('cq') end
  vim.cmd('qa')
end, 1000)" || status=1

printf '\n=== behavioural assertions ===\n'
nvim --headless -c "lua vim.defer_fn(function()
  local ok, err = pcall(dofile, '$DIR/test_behaviour.lua')
  if not ok then io.write('SUITE ERROR: ' .. tostring(err) .. '\n'); vim.cmd('cq') end
  vim.cmd('qa')
end, 1000)" || status=1

printf '\n=== integration checks ===\n'
sh "$DIR/test_integration.sh" || status=1

printf '\n'
[ "$status" -eq 0 ] && printf 'OK: everything passed\n' || printf 'FAILED\n'
exit "$status"
