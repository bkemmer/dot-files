#!/usr/bin/env bash

# Bat Catppuccin for bat
BAT_THEME_DIR="$(bat --config-dir)/themes"
mkdir -p $BAT_THEME_DIR
cp extras/Catppuccin\ Mocha.tmTheme $BAT_THEME_DIR
bat cache --build
echo 'check if "Catppuccin Mocha" is present:'
bat --list-themes

# echo "create a symlink for basedpyright-language-server"
# echo "on macos put on /usr/local/bin and on linux ~/.local/bin"
# TODO: check if there isn't already a symlink
# [[ "$OSTYPE" == "linux-gnu" ]] && ln -s $HOME/.virtualenvs/neovim/bin/basedpyright-langserver ~/.local/bin/basedpyright-language-server

# [[ "$OSTYPE" == "darwin"* ]] && ln -s $HOME/.virtualenvs/neovim/bin/basedpyright-langserver /usr/local/bin/basedpyright-language-server
