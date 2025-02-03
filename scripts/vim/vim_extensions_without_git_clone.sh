#!/usr/bin/env zsh

dl_and_mv_repo(){
    URL=$1              # url to zip file with the master branch of the repository
    ZIP=$2              # name of the zip and unziped folder ex.: dot-file-main.zip and dot-file-main
    DEST=$3             # name of the destination folder
    DOWNLOAD_FOLDER=$4  # path to the download folder
    INSTALL_FOLDER=$5   # path to be installed  

    echo ""
    [[ -e $DOWNLOAD_FOLDER/$ZIP.zip ]] && rm $DOWNLOAD_FOLDER/$ZIP.zip 
    read -s -k "?Download $URL and press a key to continue..."
    echo ""
    cd $DOWNLOAD_FOLDER
    [[ -e $DOWNLOAD_FOLDER/$ZIP.zip ]] || { echo "$ZIP.zip file not found. Exiting"; exit 1; }
    unzip -qq $ZIP.zip
    mv $ZIP $DEST
    rm -r $INSTALL_FOLDER/$DEST
    mv $DEST $INSTALL_FOLDER/$DEST
    rm $ZIP.zip
    echo ""
}
# TODO: make this reusable
# type dl_and_mv_repo &>/dev/null && echo "dl_and_mv_repo() found" || { echo "dl_and_mv_repo() not found, check ~/.functions"; exit 1; }

echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"

DOWNLOAD_FOLDER=$HOME/Downloads

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



