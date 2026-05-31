# Dot-files Suggestions

Ordered by priority (highest first). Completed items have been removed.

## High priority

- **`projects_basics/` — document or split out.** It ships its own `Makefile`
  and `pyproject.toml` and is unrelated to config management. Add a short note
  in the README explaining its purpose, or move it to a separate repo.

## Medium priority

- **Explicit `fzf` key bindings** — add `CTRL-T`, `ALT-C`, `CTRL-R` bindings in
  `.zshrc` for consistent behavior across machines, rather than relying on
  `~/.fzf.zsh` being present.
- **Consider `mise` alongside `uv`** — `pyenv` + `uv` coexist fine, but `mise`
  manages Python versions and is faster. Optional swap.

## Low priority / potential additions

- **TPM (Tmux Plugin Manager)** — replace the manual `run-shell` lines at the
  bottom of `.tmux.conf` for easier plugin management.
- **LazyGit** — pairs well with the existing git aliases and nvim workflow.
- **Starship prompt** — faster Rust alternative to Spaceship, zero zsh plugin
  dependency.
- **`direnv`** — auto-load `.envrc` files per project, useful alongside the
  `cve`/`dve` venv aliases.
