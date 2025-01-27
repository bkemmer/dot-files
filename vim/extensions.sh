#!/usr/bin/env bash

clone_repo(){
    # $1 is the url and $2 the path
    [[ -d $2 ]] || git clone --depth 1 $1 $2
}

# autostart

# Run your favorite search tool from Vim, with an enhanced results list.
clone_repo  https://github.com/mileszs/ack.vim.git ~/.vim/pack/plugins/start/ack.vim

# Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
clone_repo https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/pack/plugins/start/ctrlp.vim

# The NERDTree is a file system explorer for the Vim editor. 
clone_repo https://github.com/preservim/nerdtree.git ~/.vim/pack/plugins/start/nerdtree
vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q

# Easymotion
clone_repo https://github.com/easymotion/vim-easymotion.git ~/.vim/pack/plugins/start/vim-easymotion

# Polyglot
clone_repo  https://github.com/sheerun/vim-polyglot ~/.vim/pack/plugins/start/vim-polyglot

# Lean & mean status/tabline for vim that's light as air.
clone_repo https://github.com/vim-airline/vim-airline ~/.vim/pack/plugins/start/vim-airline

# Highlight yanked text
clone_repo https://github.com/machakann/vim-highlightedyank.git ~/.vim/pack/plugins/start/vim-highlightedyank.git 

# opt
# Onedark color
clone_repo https://github.com/joshdick/onedark.vim.git ~/.vim/pack/plugins/opt/onedark.vim  


