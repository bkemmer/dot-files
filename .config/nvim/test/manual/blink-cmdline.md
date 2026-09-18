# Completion from the first keystroke

**What changed:** blink (the completion plugin) used to configure itself only
when you first entered insert mode. Until that moment it was not set up, so
command-line completion did not work at all. It now configures at startup.

**Why check it:** this is easy to verify and easy to get wrong.

## Steps

1. Open nvim fresh:
   ```sh
   nvim
   ```
2. **Without typing anything else first**, press `:` and start typing a command,
   for example `:colo`.

**You should see:** a completion menu appear straight away.

3. Now press `Esc`, type `i` to enter insert mode, then `Esc` again.
4. Press `:` and type `:colo` again.

**You should see:** the same menu. It should be no different from step 2.

## What it means

- [ ] Menu appears both times, identically → **pass**
- [ ] Menu only appears the second time → the lazy-load is somehow still in
      place; tell me and I will look again.
