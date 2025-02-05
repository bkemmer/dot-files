#!/usr/bin/env bash
# steps from grencez.dev/2016/stow-tutorial-20160505

DOWNLOAD_FOLDER="$HOME/Downloads"
# cd ~/.local/src
URL="http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz"
FNAME="stow-latest.tar.gz"
[[ -e $DOWNLOAD_FOLDER/$FNAME ]] && rm $DOWNLOAD_FOLDER/$FNAME
read -s -k "?Download $URL and press a key to continue..."
echo ""
cd $DOWNLOAD_FOLDER
# curl -O http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar xf $FNAME
release=$(ls -Avr | grep -m1 -axEe 'stow-[0-9.]+')
cd $release

./configure --prefix ~/.local/stow/$release
make
make install

cd ~/.local/stow
./$release/bin/stow $release
cd $DOWNLOAD_FOLDER && rm -fr $release $DOWNLOAD_FOLDER

