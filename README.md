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

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com/bkemmer/dot-files.git
$ cd dot-files
```

then use GNU stow to create symlinks

```
$ stow .
```

To add the required zsh extensions run the script under `scrips` folder.

### Vscode

To setup vscode run using Makefile commands

## Scripts

Usefull scripts to setup tools

