#!/usr/bin/env zsh 

## Install fzf by cloning the repository and running ./install
dl_and_mv_repo https://github.com/junegunn/fzf/archive/refs/heads/master.zip fzf-master fzf $DOWNLOAD_FOLDER $HOME/.local
cd $HOME/.local/.fzf
install

