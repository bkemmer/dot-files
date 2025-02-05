#!/usr/bin/env zsh
source $HOME/.functions
type dl_and_mv_repo &>/dev/null && echo "dl_and_mv_repo() found" || { echo "dl_and_mv_repo() not found, check ~/.functions"; exit 1; }

echo ""
echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"

[[ -d $VIM_EXTENSIONS_PATH ]] || mkdir -p $VIM_EXTENSIONS_PATH/{start,opt}

DOWNLOAD_FOLDER=$HOME/Downloads

echo "Tip: <C-Click> in the URL download the zip using the default's browser"
echo ""

## Jedi-vim
# Autocompletions for python - jedi vim
#
# Installing jedi-vim
dl_and_mv_repo https://github.com/davidhalter/jedi-vim/archive/refs/heads/master.zip jedi-vim-master jedi-vim $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
# installing its submodules
JEDI_PYTHONX_PATH=$VIM_EXTENSIONS_PATH/start/jedi-vim/pythonx
# jedi
rm -r $JEDI_PYTHONX_PATH/jedi
dl_and_mv_repo https://github.com/davidhalter/jedi/archive/refs/heads/master.zip jedi-master jedi $DOWNLOAD_FOLDER $JEDI_PYTHONX_PATH
# parse
rm -r $JEDI_PYTHONX_PATH/parso
dl_and_mv_repo  https://github.com/davidhalter/parso/archive/refs/heads/master.zip parso-master parso $DOWNLOAD_FOLDER $JEDI_PYTHONX_PATH
# django-stubs
JEDI_PYTHONX_THIRDPARTY_PATH=$VIM_EXTENSIONS_PATH/start/jedi-vim/pythonx/jedi/jedi/third_party
rm -r $JEDI_PYTHONX_THIRDPARTY_PATH/django-stubs
dl_and_mv_repo https://github.com/davidhalter/django-stubs/archive/refs/heads/master.zip django-stubs-master django-stubs $DOWNLOAD_FOLDER $JEDI_PYTHONX_THIRDPARTY_PATH
# typeshed
rm -r $JEDI_PYTHONX_THIRDPARTY_PATH/typeshed
dl_and_mv_repo  https://github.com/davidhalter/typeshed/archive/refs/heads/jedi.zip typeshed-jedi typeshed $DOWNLOAD_FOLDER $JEDI_PYTHONX_THIRDPARTY_PATH

## Others

# autostart
 
# fzf - fuzzy finder
https://github.com/junegunn/fzf/archive/refs/heads/master.zip fzf-master fzf $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
[[ -x fzf ]] || $VIM_EXTENSIONS_PATH/start/fzf/install --bin

## Nerdtree

# The NERDTree is a file system explorer for the Vim editor. 
dl_and_mv_repo https://github.com/preservim/nerdtree/archive/refs/heads/master.zip nerdtree-master nerdtree $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
# NERDTree extensions
# nerdtree-git-plugin
dl_and_mv_repo https://github.com/Xuyuanp/nerdtree-git-plugin/archive/refs/heads/master.zip nerdtree-git-plugin-master nerdtree-git-plugin $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
# vim-nerdtree-syntax-highlight
dl_and_mv_repo https://github.com/tiagofumo/vim-nerdtree-syntax-highlight/archive/refs/heads/master.zip vim-nerdtree-syntax-highlight-master vim-nerdtree-syntax-highlight $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
# nerdtree-visual-selection
dl_and_mv_repo https://github.com/PhilRunninger/nerdtree-visual-selection/archive/refs/heads/master.zip nerdtree-visual-selection-master nerdtree-visual-selection $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start

# Easymotion
dl_and_mv_repo https://github.com/easymotion/vim-easymotion/archive/refs/heads/master.zip vim-easymotion-master vim-easymotion $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start

# Polyglot
dl_and_mv_repo  https://github.com/sheerun/vim-polyglot/archive/refs/heads/master.zip vim-polyglot-master vim-polyglot $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start

# Lean & mean status/tabline for vim that's light as air.
dl_and_mv_repo https://github.com/vim-airline/vim-airline/archive/refs/heads/master.zip vim-airline-master vim-airline $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start

# Highlight yanked text
dl_and_mv_repo https://github.com/machakann/vim-highlightedyank/archive/refs/heads/master.zip vim-highlightedyank-master vim-highlightedyank $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start

# Vim Commentary
dl_and_mv_repo https://github.com/tpope/vim-commentary/archive/refs/heads/master.zip vim-commentary-master vim-commentary $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start/commentary

# opt
# Onedark color
dl_and_mv_repo https://github.com/joshdick/onedark.vim/archive/refs/heads/main.zip onedark.vim-main onedark.vim $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/opt


# Update doc of the plugins
vim -c ':helptags ALL|q'


