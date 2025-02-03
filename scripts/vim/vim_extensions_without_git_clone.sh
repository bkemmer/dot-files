#!/usr/bin/env bash

type dl_and_mv_repo &>/dev/null && echo "dl_and_mv_repo() found" || { echo "dl_and_mv_repo() not found, check ~/.functions"; exit 1}

echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"

DOWNLOAD_FOLDER=$HOME/Downloads
alias update_dot_files="dl_and_mv_repo https://github.com/bkemmer/dot-files/archive/refs/heads/main.zip dot-files-main dot-files $HOME/Downloads $HOME/projects"

# Installing jedi-vim
dl_and_mv_repo https://github.com/davidhalter/jedi-vim/archive/refs/heads/master.zip jedi-vim-master jedi-vim $DOWNLOAD_FOLDER $VIM_EXTENSIONS_PATH/start
# installing its submodules
JEDI_PYTHONX_PATH=$VIM_EXTENSIONS_PATH/start/jedi-vim/pythonx/
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



