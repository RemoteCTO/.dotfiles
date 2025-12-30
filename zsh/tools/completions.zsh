#!/usr/bin/env zsh
# Completion setup

# hcloud completions
if [[ -d ~/.config/hcloud/completion/zsh ]]; then
    fpath+=(~/.config/hcloud/completion/zsh)
fi

# Initialise completions (only once)
autoload -Uz compinit
compinit -C  # -C skips security check for speed
