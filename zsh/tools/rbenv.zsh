#!/usr/bin/env zsh
# rbenv - Ruby version manager

if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - zsh)"
fi
