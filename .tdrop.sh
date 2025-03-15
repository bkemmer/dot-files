#!/usr/bin/env bash

# Command to toogle dropdown terminal
# kitty is the terminal emulator
# -ma is to use with multiple monitors
# -h 100% is to use 100% of the screen height
# -s is to create a tmux session (optional)
#
# Create a custom shortcut to run this command with a keybinding
tdrop -ma -h 100% -s dropdown kitty

