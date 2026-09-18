# Terminal keys

**What changed:** you had five different keys that all opened the exact same
terminal. Two of them claimed to be different ("Terminal (cwd)" vs "Terminal
(Root Dir)") but were identical, because snacks already defaults to the current
directory. Cut down to three keys, two of which are the same physical keypress.

**Why it is manual:** `Ctrl-/` and `Ctrl-_` are the *same key*. Most terminals
send `Ctrl-/` as the byte `0x1F`, which nvim reads as `Ctrl-_`. Which one your
terminal sends cannot be tested without a real terminal.

## Steps

1. Open nvim.
2. Press `Ctrl-/`.

**You should see:** a terminal open.

3. Press `Ctrl-/` again.

**You should see:** it close.

4. Press `<leader>ft`.

**You should see:** the same terminal open again.

## What it means

- [ ] `Ctrl-/` opens and closes a terminal → **pass**
- [ ] Nothing happens on `Ctrl-/` → your terminal sends something else. Find out
      what by typing `<leader>ft` to get a terminal, then in nvim run
      `:lua vim.keymap.set("n", "<C-_>", function() print("got C-_") end)` and
      experiment. Tell me the result and I will bind the right key.
- [ ] `<leader>fT` still works → it should be gone now; tell me.
