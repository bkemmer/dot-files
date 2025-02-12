#!/usr/bin/env bash

echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"
[[ -d $VIM_EXTENSIONS_PATH ]] || mkdir -p $VIM_EXTENSIONS_PATH


clone_repo(){
    # $1 is the url and $2 the path
    if ! [[ -d $2 ]]; then echo "Installing $1 on $2" && git clone --depth 1 $1 $2
        # try to add the documentation if the /doc folder exists
        [[ -d $2/doc ]] && (echo "Adding helptag on $2" && vim -u NONE -c "helptags $2/doc" -c q)
        echo ""
    fi
}

# autostart

# ACK - Run your favorite search tool from Vim, with an enhanced results list.
clone_repo  https://github.com/mileszs/ack.vim.git $VIM_EXTENSIONS_PATH/start/ack.vim

# fzf - fuzzy files finder
clone_repo https://github.com/junegunn/fzf.git $VIM_EXTENSIONS_PATH/start/fzf
[[ -x fzf ]] || $VIM_EXTENSIONS_PATH/start/fzf/install --bin

# The NERDTree is a file system explorer for the Vim editor. 
clone_repo https://github.com/preservim/nerdtree.git $VIM_EXTENSIONS_PATH/start/nerdtree

# NERDTree extensions
# nerdtree-git-plugin
clone_repo https://github.com/Xuyuanp/nerdtree-git-plugin.git $VIM_EXTENSIONS_PATH/start/nerdtree-git-plugin
# vim-nerdtree-syntax-highlight
clone_repo https://github.com/tiagofumo/vim-nerdtree-syntax-highlight.git $VIM_EXTENSIONS_PATH/start/vim-nerdtree-syntax-highlight
# nerdtree-visual-selection
clone_repo https://github.com/PhilRunninger/nerdtree-visual-selection.git $VIM_EXTENSIONS_PATH/start/nerdtree-visual-selection 

# Easymotion
clone_repo https://github.com/easymotion/vim-easymotion.git $VIM_EXTENSIONS_PATH/start/vim-easymotion

# Polyglot
clone_repo  https://github.com/sheerun/vim-polyglot $VIM_EXTENSIONS_PATH/start/vim-polyglot

# Lean & mean status/tabline for vim that's light as air.
clone_repo https://github.com/vim-airline/vim-airline $VIM_EXTENSIONS_PATH/start/vim-airline

# Highlight yanked text
clone_repo https://github.com/machakann/vim-highlightedyank.git $VIM_EXTENSIONS_PATH/start/vim-highlightedyank 

# Autocompletions for python - jedi vim
clone_repo https://github.com/davidhalter/jedi-vim.git $VIM_EXTENSIONS_PATH/start/jedi-vim
cd $VIM_EXTENSIONS_PATH/start/jedi-vim
# https://github.com/davidhalter/jedi-vim.git
git submodule update --init --recursive

# Vim Commentary
clone_repo https://tpope.io/vim/commentary.git $VIM_EXTENSIONS_PATH/start/commentary

# Vim-slime for REPL
clone_repo https://github.com/jpalardy/vim-slime.git $VIM_EXTENSIONS_PATH/start/vim-slime

# opt
# Onedark color
clone_repo https://github.com/joshdick/onedark.vim.git $VIM_EXTENSIONS_PATH/opt/onedark.vim  



vim -u NONE -c "helptags ALL" -c q

