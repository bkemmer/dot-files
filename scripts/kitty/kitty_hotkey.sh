#!/bin/bash
ACTIVE_WINDOW=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW|cut -f 2)
ACTIVE_WINDOW_CLASS=$(xprop -id $ACTIVE_WINDOW WM_CLASS|tr -d ,\"|awk '{print $3};')

if [ $ACTIVE_WINDOW_CLASS = "kitty" ]; then
  wmctrl -ia $(cat ~/.lastfocusedwindow)
else
  echo $ACTIVE_WINDOW > ~/.lastfocusedwindow
  wmctrl -xa kitty.kitty || ~/.local/kitty.app/bin/kitty
fi
