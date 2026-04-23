#!/usr/bin/env bash
# tmux-sessionizer — fuzzy-jump to any project, auto-creates tmux session
# Based on ThePrimeagen's sessionizer: https://github.com/ThePrimeagen/.dotfiles
#
# Usage:
#   tmux-sessionizer           → fzf picker across ~/projects, ~/work, ~/workspace
#   tmux-sessionizer <path>    → jump directly to a path
#
# Bind in ~/.zshrc:
#   bindkey -s ^f "tmux-sessionizer\n"
#
# Bind in ~/.tmux.conf.local:
#   bind-key -r f run-shell "tmux neww ~/bin/tmux-sessionizer"

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(find \
    ~/projects ~/work ~/workspace \
    "$HOME/.openclaw/workspace" \
    -mindepth 1 -maxdepth 2 -type d 2>/dev/null | fzf --prompt="session> ")
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
