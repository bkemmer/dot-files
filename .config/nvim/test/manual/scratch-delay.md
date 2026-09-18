# The pause on `<leader>.`

**What changed:** `<leader>.` opens a scratch buffer. It now has a second key
underneath it, `<leader>.s`, which opens a picker of all your scratch buffers.

**The trade-off:** whenever a key has another key underneath it, vim has to wait
to see whether you are going to press the second one. So `<leader>.` now pauses
for 300ms before it does anything. That is unavoidable — it is how vim resolves
ambiguous mappings, and your `timeoutlen` is 300.

**Why check it:** only you can say whether that pause is annoying.

## Steps

1. Open nvim.
2. Press `<leader>.` and pay attention to how long it takes to respond.

**You will see:** a scratch buffer, after a short but noticeable delay.

3. Press `<leader>.` again to close it. Repeat a few times.

## What it means

- [ ] The pause is fine → **pass**, nothing to do
- [ ] The pause is annoying → tell me. The fix is to move the picker somewhere
      that is not underneath `<leader>.`, for example `<leader>s.`, which
      removes the delay completely. You had picked `.s` over `s.` earlier, so
      this is just a chance to change your mind now you can feel it.

## Background

You have never actually used scratch buffers — there was no
`~/.local/share/nvim/scratch/` directory at all — so this may not matter to you
either way.
