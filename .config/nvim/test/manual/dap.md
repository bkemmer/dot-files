# Debugger (DAP)

**What changed:** you had three debugger plugins installed and configured, with
no keys bound to any of them. The debugger was unreachable. It now has keymaps.

**Before you start:** the debugger cannot run until `debugpy` is installed. It
is not currently on your system.

```sh
uv pip install debugpy
# or, if you are not using uv:
python3 -m pip install --user debugpy
```

## Steps

1. Make a small Python file to debug:
   ```sh
   printf 'def add(a, b):\n    total = a + b\n    return total\n\nprint(add(2, 3))\n' > /tmp/dbg.py
   nvim /tmp/dbg.py
   ```
2. Put the cursor on the line `total = a + b`.
3. Press `<leader>db`.

**You should see:** a red dot or marker appear in the left margin.

4. Press `<leader>dc` to start.

**You should see:** the debugger starts and stops on your breakpoint line.

5. Press `<leader>du`.

**You should see:** a panel open showing variables, with `a` and `b` in it.

6. Press `<leader>do` to step to the next line.

**You should see:** the highlight move down one line, and `total` appear in the
variables panel with the value 5.

7. Press `<leader>dt` to stop.

## All the keys

| Key | Does |
|---|---|
| `<leader>db` | breakpoint on/off |
| `<leader>dB` | breakpoint with a condition (it asks you for one) |
| `<leader>dc` | start, or continue to the next breakpoint |
| `<leader>di` | step into |
| `<leader>do` | step over |
| `<leader>dO` | step out |
| `<leader>dr` | open the debug REPL |
| `<leader>du` | show/hide the variables panel |
| `<leader>dt` | stop |

`F5` `F10` `F11` `F12` also work, for continue / over / into / out.

## What it means

- [ ] It stops on the breakpoint and shows variables → **pass**
- [ ] "No configuration found" or nothing happens → `debugpy` is probably still
      missing. Check with `python3 -c "import debugpy"`.
- [ ] It starts but does not stop → the breakpoint did not register; check the
      marker really appeared in step 3.
