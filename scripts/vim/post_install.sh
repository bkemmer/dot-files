#!/usr/bin/env bash

LIGHTLINE_COLORSCHEME_PATH="$VIMCONFIG/pack/plugins/start/lightline/autoload/lightline/colorscheme"

[[ -d $LIGHTLINE_COLORSCHEME_PATH ]] && cp "extras/onedark.vim" $LIGHTLINE_COLORSCHEME_PATH/
