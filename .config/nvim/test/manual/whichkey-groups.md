# which-key menu labels

**What changed:** the popup menu had labels for plugins you do not have
(Diffview, Yanky) and for prefixes with nothing under them (tabs, hunks,
diagnostics/quickfix). Meanwhile prefixes you use every day had no label at
all — `<leader>j` showed thirteen unnamed pyrepl keys.

**Why it is manual:** reading these labels back in a script needs which-key's
private internals, which would break on plugin updates. Looking is faster.

## Steps

1. Open nvim and press `<leader>` (space). Wait for the popup.

**You should see** these labels:

| Key | Label |
|---|---|
| `j` | python repl |
| `m` | miniharp marks |
| `r` | review |
| `S` | session |
| `t` | toggle |
| `;` | substitute |
| `p` | plugins (vim.pack) |

**You should NOT see:** Diffview, Yanky, tabs, hunks, or diagnostics/quickfix.

2. Press `j` (so you have pressed `<leader>j`).

**You should see:** the pyrepl commands, each with a description.

3. Press `Esc`, then `<leader>S`.

**You should see:** four session entries — save, load, write, read last.

## What it means

- [ ] Labels match, no ghost groups → **pass**
- [ ] A ghost group is still listed → tell me which one and I will remove it.
- [ ] A group shows as a bare letter with no name → tell me which prefix.
