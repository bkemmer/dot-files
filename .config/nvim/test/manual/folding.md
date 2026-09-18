# Folding

**What changed:** `foldmethod` used to be `manual`, which meant the treesitter
fold expression in the config never actually did anything. It is now `expr`, so
folding is live for the first time.

**Why check it:** this is the change most likely to feel wrong. If the fold
level were set badly, you would open a file and find it collapsed into a few
lines.

## Steps

1. Open a big Python file:
   ```sh
   nvim some_long_file.py
   ```
2. Look at it.

**You should see:** the whole file, fully expanded, exactly as before.

3. Put the cursor inside a function and press `zc`.

**You should see:** that function collapses to one line.

4. Press `zR`.

**You should see:** everything expands again.

## What it means

- [ ] File opens fully expanded, `zc` folds, `zR` unfolds → **pass**
- [ ] File opens with things already folded → the fold level is wrong. Tell me
      and I will set `foldlevel` higher or turn folding back off.
- [ ] `zc` does nothing → the fold expression is not working; treesitter may not
      have a parser for that language.

## Note

The automated suite already checks this on a fixture: `foldmethod` is `expr`,
`foldlevel` is 99, and no line is inside a closed fold when a file opens. This
manual check exists because "does it feel right in a file I actually work on"
is a different question from "do the numbers look right".
