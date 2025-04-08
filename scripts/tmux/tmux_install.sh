#!/usr/bin/env bash

# Install tpm
command -v tmux &>/dev/null || { echo "tmux is not installed. Please install tmux first."; exit 1; }

TMUX_PLUGINS_DIR=~/.tmux/plugins
mkdir -p $TMUX_PLUGINS_DIR

# avoiding git
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install_tmux_plugin() {
  local plugin_name=$1
  local plugin_url=$2
  local plugin_dir="$TMUX_PLUGINS_DIR/$plugin_name"

  if [ -d "$plugin_dir" ]; then
    echo "$plugin_name already exists"
  else
    echo "Installing $plugin_name"
    git clone "$plugin_url" "$plugin_dir"
  fi
}

install_tmux_plugin "tmux-sensible" "https://github.com/tmux-plugins/tmux-sensible"
install_tmux_plugin "tmux-resurrect" "https://github.com/tmux-plugins/tmux-resurrect"

install_tmux_plugin "tmux-continuum" "https://github.com/tmux-plugins/tmux-continuum"
install_tmux_plugin "tmux-yank" "https://github.com/tmux-plugins/tmux-yank"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Installing reattach-to-user-namespace"
  brew install reattach-to-user-namespace
fi
