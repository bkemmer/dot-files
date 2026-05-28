# Dot-files Suggestions

## .zshrc

- **Replace `neofetch` with `fastfetch`** — neofetch is unmaintained; fastfetch is faster and actively developed.
- **Shell startup order**: sourcing `oh-my-zsh` before setting up `pyenv` and `zoxide` is fine, but consider moving all `PATH` exports above `source $ZSH/oh-my-zsh.sh` so plugins that depend on PATH see the right binaries.
- **`command_exists` is already defined in `.zshrc` but not shared with `.functions`** — either move it to `.functions` or source `.functions` before the check.
- **`cat /etc/*-release | grep` (line 61)** — useless use of `cat`; replace with `grep -q 'Red Hat' /etc/*-release`.
- **Consider `mise` (or keep `pyenv`) alongside `uv`** — you already have `uv` in `.local/bin`; `pyenv` + `uv` can coexist but `mise` manages Python versions and is faster.

## .aliases

- **`v=nvim` is defined twice** — once in `.zshrc` (line 35) and once in `.aliases` (line 8). Remove the duplicate in `.aliases`.
- **`gcb` uses `xclip`** (line 38) which is Linux-only; add a macOS fallback with `pbcopy` like you did in `.tmux.conf`:
  ```sh
  gcb() { git rev-parse --abbrev-ref HEAD | if command -v pbcopy &>/dev/null; then pbcopy; else xclip -selection clipboard; fi }
  ```
- **`restart_gnome`** and **`nvidia_monitor`** are Linux-only but always loaded. Wrap in an `[[ "$OSTYPE" == linux-gnu* ]]` guard or move to `.popos_configs`.

## .functions

- **`git-list-stale-branchs`** — typo in function name (`branchs` → `branches`).

## .tmux.conf

- **Duplicate swap-window bindings** — `bind-key S-Left/S-Right` (lines 96–97) and `bind-key C-b < / >` (lines 154–155) both swap windows. The `C-b` bindings shadow the original tmux prefix (`C-b` was unbound on line 6 and reassigned to `C-a`). The `C-b` swap bindings will silently fail or conflict; remove one set.
- **Consider `tmux-plugin-manager` (TPM)** to replace the manual `run-shell` lines at the bottom — easier to add/remove plugins.

## Makefile

- **`keybidings.json`** is misspelled throughout (should be `keybindings`) — affects both the Makefile targets and the `vscode/` directory filename. Fix the filename and all references.
- **`symlink_*_vscode` targets don't check if the symlink already exists** — `ln -s` will fail silently or error on re-runs. Add `-f` flag or a guard.
- **`setup` target calls `./scripts/nvim/install_vim_plugins.py`** which doesn't exist in the repo (only `pre_install.sh` and `post_install.sh` are present). Either add the script or remove the reference.
- **Add a `help` target** that prints descriptions (already partially done via `print`, but use the `## comment` convention with `awk` for cleaner output).

## Repo / Stow hygiene

- **`.DS_Store` files** are committed in `.config/nvim/` and `.config/nvim/lua/plugins/`. Add `**/.DS_Store` to `.gitignore`.
- **`.stow-local-ignore` is empty or missing entries** — verify it ignores `README.md`, `Makefile`, `scripts/`, `TODOs.md`, `SUGGESTIONS.md`, and `vscode/` so `stow .` doesn't try to symlink them into `$HOME`.
- **`projects_basics/` directory** has its own `Makefile` and `pyproject.toml` — document its purpose in the README or move it to a separate repo if it's unrelated to config management.

## README.md

- The `git clone` URL (line 14) is missing the colon — it reads `git@github.com/bkemmer/dot-files.git` (slash instead of colon after the hostname).
- Extend the README to document: shell dependencies (oh-my-zsh, zsh plugins), tool list (bat, ripgrep, fzf, fd, zoxide, yazi), and platform-specific notes for macOS vs Linux.

## Potential additions

- **`LazyGit`** — pairs well with the existing git aliases and nvim workflow.
- **`yazi` shell integration** — add the `y()` wrapper function to `.functions` so `yazi` changes the working directory on exit.
- **`fzf` key bindings** — run `$(brew --prefix)/opt/fzf/install` or add `CTRL-T`, `ALT-C`, `CTRL-R` bindings explicitly in `.zshrc` for consistent behavior across machines.
- **Starship prompt** as an alternative to Spaceship — faster, written in Rust, zero zsh plugin dependency.
- **`direnv`** — auto-load `.envrc` files per project, useful alongside your `cve`/`dve` venv aliases.
