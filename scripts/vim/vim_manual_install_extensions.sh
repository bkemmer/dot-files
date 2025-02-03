#!/usr/bin/env bash

echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"
[[ -d $VIM_EXTENSIONS_PATH ]] || mkdir -p $VIM_EXTENSIONS_PATH

# TODO: needed to make vim-devicons work
#if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#    mkdir -p ~/.local/share/fonts
#    cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
#elif [[ "$OSTYPE" == "darwin"* ]]; then
#    brew install font-hack-nerd-font
#else
#    echo "Platform not expected $OSTYPE"
#fi


clone_repo(){
    # $1 is the url and $2 the path
    [[ -d $2 ]] || (echo "Installing $1 on $2" && git clone --depth 1 $1 $2)
    # try to add the documentation if the /doc folder exists
    [[ -d $2/doc ]] && (echo "Adding helptag on $2" && vim -u NONE -c "helptags $2/doc" -c q)
    echo ""
}

# autostart

# Run your favorite search tool from Vim, with an enhanced results list.
clone_repo  https://github.com/mileszs/ack.vim.git $VIM_EXTENSIONS_PATH/start/ack.vim

# Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
clone_repo https://github.com/ctrlpvim/ctrlp.vim.git $VIM_EXTENSIONS_PATH/start/ctrlp.vim

# The NERDTree is a file system explorer for the Vim editor. 
clone_repo https://github.com/preservim/nerdtree.git $VIM_EXTENSIONS_PATH/start/nerdtree

# NERDTree extensions
# nerdtree-git-plugin
clone_repo https://github.com/Xuyuanp/nerdtree-git-plugin.git $VIM_EXTENSIONS_PATH/start/nerdtree-git-plugin
# vim-devicons 

# brew install font-hack-nerd-font
#clone_repo https://github.com/ryanoasis/vim-devicons.git $VIM_EXTENSIONS_PATH/start/vim-devicons
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

# opt
# Onedark color
clone_repo https://github.com/joshdick/onedark.vim.git $VIM_EXTENSIONS_PATH/opt/onedark.vim  

