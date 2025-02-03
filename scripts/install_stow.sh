#!/usr/bin/env bash

# steps from grencez.dev/2016/stow-tutorial-20160505

cd ~/local/src
curl -O http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
tar xf stow-latest.tar.gz
release=$(ls -Avr | grep -m1 -axEe 'stow-[0-9.]+')
cd $release

./configure --prefix ~/local/stow/$release
make
make install

cd ~/local/stow
cd ~/local/src && rm -fr $release stow-latest.tar.gz

