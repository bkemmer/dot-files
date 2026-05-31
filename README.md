# My dotfiles

This directory contains the dotfiles for my system, managed with GNU stow.

## What's included

| Path | Description |
|------|-------------|
| `.zshrc`, `.aliases`, `.functions` | zsh config, aliases, and helper functions |
| `.tmux.conf` | tmux configuration |
| `.vimrc`, `.config/nvim` | vim and Neovim configuration |
| `.ripgreprc`, `.inputrc` | ripgrep and readline config |
| `.venv_wrapper` | Python virtualenv helpers |
| `.rhel_configs` | Red Hat / RHEL-specific shell config |
| `.hammerspoon` | macOS automation (Hammerspoon) |
| `.tdrop.sh` | dropdown terminal helper (Linux) |
| `vscode/` | VSCode / Antigravity settings, keybindings, extensions |
| `scripts/` | setup and install scripts (see [Scripts](#scripts)) |

## Requirements

Ensure you have the following installed on your system

### Git

```
apt install git
```

### Stow

```
apt install stow
```

Manual installation script under `scripts/manual_installations_scripts/install_stow.sh`

### Shell

- [oh-my-zsh](https://ohmyz.sh/) — zsh framework
- zsh plugins (clone into `$ZSH_CUSTOM/plugins/`):
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode)
- [Spaceship prompt](https://spaceship-prompt.sh/)

The zsh plugins can be cloned automatically with `scripts/zsh_install_extensions.sh`.

### tmux

`.tmux.conf` expects these plugins under `~/.tmux/plugins/`:
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank)

Install them with `scripts/tmux/tmux_install.sh`.

### CLI tools

| Tool | Purpose |
|------|---------|
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast grep |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [fd](https://github.com/sharkdp/fd) | Fast `find` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |
| [eza](https://github.com/eza-community/eza) | Modern `ls` |

### Platform-specific

**macOS** — install tools via Homebrew:
```
brew install bat ripgrep fzf fd zoxide yazi eza fastfetch
```

**Linux (Ubuntu/PopOS)** — use the setup script:
```
./scripts/linux/setup.sh
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:bkemmer/dot-files.git
$ cd dot-files
```

then use GNU stow to create symlinks

```
$ stow .
```

To install the required zsh plugins run `scripts/zsh_install_extensions.sh`.

### Neovim & extras

`make setup` runs the Neovim pre/post-install scripts. Run `make help` to see
all available targets.

### VSCode

To setup VSCode symlinks run:

```
make symlink_macos_vscode   # macOS
make symlink_linux_vscode   # Linux
```

Install the tracked extensions with `make install_vscode_extensions`.

## Scripts

Useful scripts to set up tools, grouped under `scripts/`:

| Path | Purpose |
|------|---------|
| `linux/setup.sh` | apt packages and CLI tools (Ubuntu/PopOS) |
| `macos/homebrew_commands.sh`, `macos/initial_setup_commands.sh` | macOS Homebrew + initial setup |
| `zsh_install_extensions.sh` | clone the oh-my-zsh plugins |
| `tmux/tmux_install.sh` | install tmux plugins into `~/.tmux/plugins/` |
| `nvim/pre_install.sh`, `nvim/post_install.sh` | Neovim setup (run by `make setup`) |
| `fonts/` | Nerd Fonts installation steps |
| `sagemaker/` | Neovim install for SageMaker environments |
| `manual_installations_scripts/install_stow.sh` | build/install GNU stow from source |
| `tools_aux/` | helper utilities (font/color checks) |

