#!/usr/bin/env sh
sudo apt update 
sudo apt upgrade -y 
sudo apt install -y curl wget git zsh tmux htop neofetch gawk
sudo apt install -y python3 python3-pip python3-venv
sudo apt install -y build-essential cmake python3-dev checkinstall libssl-dev
#
# install kitty terminal on last version
# curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# 
echo 'install tdrop' 
