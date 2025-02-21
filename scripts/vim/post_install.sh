#!/usr/bin/env bash

# Pasting lightline onedark colorscheme
LIGHTLINE_COLORSCHEME_PATH="$VIMCONFIG/pack/plugins/start/lightline/autoload/lightline/colorscheme"
[[ -d $LIGHTLINE_COLORSCHEME_PATH ]] && cp "extras/onedark.vim" $LIGHTLINE_COLORSCHEME_PATH/

# Moding coc package.json to CoC
COC_EXTENSIONS_PATH="$HOME/.config/coc/extensions"
[[ -d $COC_EXTENSIONS_PATH ]] && cp "extras/package.json" $COC_EXTENSIONS_PATH/
