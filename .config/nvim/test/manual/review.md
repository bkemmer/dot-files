# review.nvim

**What changed:** this plugin is new. It gives you a branch-review UI inside
nvim — a file tree of what changed, with somewhere to write comments — and it
can send those comments to a herdr pane, which is why it suits your setup.

**Why it is manual:** the send step needs a live herdr session, which a headless
test cannot have.

## Steps

1. Go to a git repo with some uncommitted changes or a branch ahead of main:
   ```sh
   cd ~/projects/dot-files
   nvim
   ```
2. Press `<leader>rr`.

**You should see:** the review UI open, listing changed files.

3. Move to a line in one of the diffs and press `<leader>rc`.

**You should see:** a prompt to write a comment.

4. Type something and confirm.

**You should see:** a marker appear on that line.

5. Press `<leader>rp`.

**You should see:** a panel listing your comments.

6. With a herdr pane open beside you, run `:Review send`.

**You should see:** your comments appear in the other pane.

## The keys

| Key | Does |
|---|---|
| `<leader>rr` | open/close the review UI |
| `<leader>rc` | comment on the current line |
| `<leader>rp` | show/hide the comments panel |
| `<leader>re` | copy all comments as markdown |
| `<leader>rs` | send comments to a herdr pane |

## What it means

- [ ] UI opens, comments stick, send reaches a pane → **pass**
- [ ] `:Review` is not a command → the plugin did not load; tell me.
- [ ] Everything works except send → that is a herdr targeting question, not an
      nvim one. Tell me and I will look at the plugin's pane target setting.
