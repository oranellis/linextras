#
# ~/.bash_profile
#

# Development Path Env Vars

export DEV_PATH="$HOME/Dev"
export SDK_PATH="$HOME/Dev/SDKs"

# Additional $PATH locations

export PATH="$PATH:~/.local/bin"

# Set Neofetch var

export FIRST_TERMINAL_OPENED=""

# Run bashrc

[[ -f ~/.bashrc ]] && . ~/.bashrc
