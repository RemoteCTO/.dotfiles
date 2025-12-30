#!/usr/bin/env zsh
# PATH configuration - loaded early, sourced once

# Prevent duplicate PATH entries
typeset -U path

# Core paths (order matters - first wins)
path=(
    "$HOME/.local/bin"
    "$HOME/.rbenv/bin"
    "$HOME/.pyenv/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/libpq/bin"
    "/opt/homebrew/opt/postgresql@17/bin"
    "/usr/local/bin"
    $path
)

export PATH
