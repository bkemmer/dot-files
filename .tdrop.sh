#!/usr/bin/env bash

# Command to toogle dropdown terminal
# kitty is the terminal emulator
# -ma is to use with multiple monitors
# -h 100% is to use 100% of the screen height
# -s is to create a tmux session (optional) droped this now that I am using herdr
#
# Create a custom shortcut to run this command with a keybinding (ex.: F12)
tdrop -ma -h 100% kitty herdr

# If needed add the --override argument in the kitty.desktop file
# kitty -o hide_window_decorations=no

