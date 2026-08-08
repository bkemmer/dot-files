# Banned / restricted commands

Do not run these without explicit confirmation from the user.

## Destructive git
- `git push --force`, `--force-with-lease` (especially to main/master)
- `git reset --hard`
- `git checkout .`, `git restore .`, `git clean -f`/`-fd`
- `git commit --amend` on pushed/shared commits
- `git branch -D`
- `-c commit.gpgsign=false`, `--no-gpg-sign`

## Filesystem
- `rm -rf /` or `rm -rf` on broad/unchecked paths
- `chmod -R 777`
- writing outside the project directory or to `$HOME` dotfiles without asking

## Bypassing safety/CI
- `--no-verify` (skip git hooks)
- disabling lint/test steps to force CI green

## Package/dependency management
- `npm install -g` / global installs
- removing or downgrading dependencies without asking
- hand-editing lockfiles
- `pip install` outside a venv

## Network/system
- `curl | bash` or any pipe-to-shell
- `sudo` anything
- `kill -9`, `pkill` on arbitrary processes
- modifying `/etc`, system services, cron

## Secrets
- `cat .env`, dumping credentials files
- committing `.env`, `credentials.json`, or similar

## Database
- `DROP TABLE`, `TRUNCATE`, raw prod DB writes/migrations without review

## Misc
- no `sleep`-loop polling
- no `find /` (scan from a known root)
- no interactive flags (`-i`) — agents can't respond to prompts
- prefer `read` over `sed`

## Git
- **Never commit** unless explicitly asked by the user (e.g., "commit this", "git commit", "push")
- Do not run `git add`, `git commit`, or `git push` on your own
- Write commit messages, PR titles and bodies in **English**

## Language
- Plans and design documents: **English**
- Code comments, docstrings and UI text follow whatever the project already uses

## Python
- Prefer `uv` over `pip` (`uv add`, `uv run`, `uv sync`), unless the project already uses a different tool
- Always use `pytest` and `pytest-mock` for unit tests

## File Discovery
- When reading or listing repository files, **skip** `.git/` and `.venv/` directories
- Use `find . -not -path './.git/*' -not -path './.venv/*'` or `ls` with appropriate filters
- Do not read or suggest changes to files inside `.git/` or `.venv/`
