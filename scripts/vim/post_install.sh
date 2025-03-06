#!/usr/bin/env bash

# Pasting lightline onedark colorscheme
LIGHTLINE_COLORSCHEME_PATH="$VIMCONFIG/pack/plugins/start/lightline/autoload/lightline/colorscheme"
[[ -d $LIGHTLINE_COLORSCHEME_PATH ]] && cp "extras/onedark.vim" $LIGHTLINE_COLORSCHEME_PATH/

# Install pyright
npm i -g pyright

