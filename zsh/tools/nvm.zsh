#!/usr/bin/env zsh
# nvm - Node version manager

export NVM_DIR="$HOME/.nvm"

# Homebrew nvm
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
    # Load completions
    [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \
        source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi
