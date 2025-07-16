#!/bin/bash

win_id=$(xdotool getwindowfocus)

term_pid=$(xprop -id "$win_id" _NET_WM_PID | awk '{print $3}')

shell_pid=$(pgrep -P "$term_pid" -a | grep -E 'bash|zsh|fish' | awk '{print $1}' | head -n1)

if [ -n "$shell_pid" ]; then
  cwd=$(readlink "/proc/$shell_pid/cwd")
else
  cwd=$(readlink "/proc/$term_pid/cwd")
fi

[ -z "$cwd" ] && cwd="$HOME"

ghostty --working-directory="$cwd"
