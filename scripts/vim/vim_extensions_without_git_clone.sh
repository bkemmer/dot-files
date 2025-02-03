#!/usr/bin/env bash

echo "VIMCONFIG: $VIMCONFIG"

VIM_EXTENSIONS_PATH="$VIMCONFIG/pack/plugins"
echo "Installing plugins on $VIM_EXTENSIONS_PATH"

dl_and_mv_repo(){
    # $1 url to zip file with the master branch of the vim plugin
    # $2 name of the unziped folder ex.: jedi-vim-master
    # $3 plugin destination folder ex.: jedi-vim
    # $4 path to be installed ex.: $VIM_EXTENSIONS_PATH/start
    echo "Downloading $3 plugin"
    cd $4
    curl -L -o master.zip $1
    unzip -qq master.zip
    mv $2 $3
    rm master.zip
    echo ""
}

# Installing jedi-vim
dl_and_mv_repo https://github.com/davidhalter/jedi-vim/archive/refs/heads/master.zip jedi-vim-master jedi-vim $VIM_EXTENSIONS_PATH/start
# installing its submodules
JEDI_PYTHONX_PATH=$VIM_EXTENSIONS_PATH/start/jedi-vim/pythonx/
# jedi
rm -r $JEDI_PYTHONX_PATH/jedi
dl_and_mv_repo https://github.com/davidhalter/jedi/archive/refs/heads/master.zip jedi-master jedi $JEDI_PYTHONX_PATH
# parse
rm -r $JEDI_PYTHONX_PATH/parso
dl_and_mv_repo  https://github.com/davidhalter/parso/archive/refs/heads/master.zip parso-master parso $JEDI_PYTHONX_PATH
# django-stubs
JEDI_PYTHONX_THIRDPARTY_PATH=$VIM_EXTENSIONS_PATH/start/jedi-vim/pythonx/jedi/jedi/third_party
rm -r $JEDI_PYTHONX_THIRDPARTY_PATH/django-stubs
dl_and_mv_repo https://github.com/davidhalter/django-stubs/archive/refs/heads/master.zip django-stubs-master django-stubs $JEDI_PYTHONX_THIRDPARTY_PATH
# typeshed
rm -r $JEDI_PYTHONX_THIRDPARTY_PATH/typeshed
dl_and_mv_repo  https://github.com/davidhalter/typeshed/archive/refs/heads/jedi.zip typeshed-jedi typeshed $JEDI_PYTHONX_THIRDPARTY_PATH



