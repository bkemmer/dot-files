# My dotfiles

This directory contains the dotfiles for my system

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

Manual installation script under `scripts/install_stow.sh`

### Shell

- [oh-my-zsh](https://ohmyz.sh/) — zsh framework
- zsh plugins (clone into `$ZSH_CUSTOM/plugins/`):
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode)
- [Spaceship prompt](https://spaceship-prompt.sh/)

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

To add the required zsh extensions run the script under `scripts` folder.

### VSCode

To setup VSCode symlinks run:

```
make symlink_macos_vscode   # macOS
make symlink_linux_vscode   # Linux
```

## Scripts

Useful scripts to setup tools

