#!/usr/bin/env bash

# Install pyright
npm i -g pyright

# Bat Catppuccin for bat
BAT_THEME_DIR="$(bat --config-dir)/themes" 
mkdir -p $BAT_THEME_DIR
cp extras/Catppuccin\ Mocha.tmTheme $BAT_THEME_DIR
bat cache --build
echo 'check if "Catppuccin Mocha" is present:'
bat --list-themes
