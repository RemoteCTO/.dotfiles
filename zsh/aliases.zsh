#!/usr/bin/env zsh
# Shell aliases

# Navigation & listing
alias ll="ls -lah"

# Editors
alias ad="code ."

# Homebrew
alias bu='brew update'
alias bug='brew upgrade'

# Ruby/Rails
alias be="bundle exec"

# Safety
alias del="trash"

# Dotfiles management
alias dot='cd ~/.dotfiles'
alias dotrc='$EDITOR ~/.dotfiles'

# Reload shell
alias reload='source ~/.zshrc'

# macOS Bluetooth (legacy)
alias btoff="sudo kextunload -b \
    com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport"
alias bton="sudo kextload -b \
    com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport"
