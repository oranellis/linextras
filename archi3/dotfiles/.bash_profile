#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export EDITOR="vim"

if [ -z "$SSH_CLIENT" ]
then
    exec startx
fi
