# Manual checks

Everything that could be automated already is — run `sh ../run.sh` for that
(138 assertions). The files here cover what a script genuinely cannot see:
things needing a real terminal, a live debugger, or your judgement about
whether something feels right.

Work through them in this order. The first two are the ones most likely to
find a real problem.

| File | Checks | Time |
|---|---|---|
| [folding.md](folding.md) | Folds don't collapse your files | 2 min |
| [dap.md](dap.md) | The debugger actually runs | 5 min |
| [blink-cmdline.md](blink-cmdline.md) | Completion works from the first keystroke | 1 min |
| [whichkey-groups.md](whichkey-groups.md) | Menu labels are right | 2 min |
| [scratch-delay.md](scratch-delay.md) | The pause on `<leader>.` is tolerable | 1 min |
| [terminal-keys.md](terminal-keys.md) | Ctrl-/ opens a terminal | 1 min |
| [sessions.md](sessions.md) | Saving and restoring a session | 3 min |
| [kitty-theme.md](kitty-theme.md) | Colours unchanged after removing the sync | 2 min |
| [review.md](review.md) | review.nvim, including send-to-herdr | 3 min |
| [startup-time.md](startup-time.md) | Startup got faster | 1 min |

Tick a box when it passes. If something fails, the file says what it means.
