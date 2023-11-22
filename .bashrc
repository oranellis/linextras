#
# Oran's bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

# History Settings

HISTCONTROL=ignoreboth
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000

# Update window size on command exec

[[ $DISPLAY ]] && shopt -s checkwinsize

# Colour setup

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null;
then
	color_prompt=yes
else
	color_prompt=
fi

if command -v git &>/dev/null
then
	source /usr/share/git/completion/git-prompt.sh
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWCOLORHINTS=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWUPSTREAM="auto"

	if [ "$color_prompt" = yes ]; then
		if [ -n "$SSH_CLIENT" ]
		then
			if [ "$USER" = root ]; then
				export PS1='\[\e[1;36m\]\u\[\e[0;36m\](\h) \[\e[0;97m\]\w\[\e[0m\]$(__git_ps1 " \[\e[1;33m\](%s\[\e[1;33m\])")\[\e[0m\]\$ '
			else
				export PS1='\[\e[1;35m\]\u\[\e[0;35m\](\h) \[\e[0;97m\]\w$(__git_ps1 " \[\e[1;33m\](%s\[\e[1;33m\])")\[\e[0m\]\$ '
			fi
		else
			export PS1='\[\e[1;36m\]\u \[\e[0;97m\]\w\[\e[0m\]$(__git_ps1 " \[\e[1;33m\](%s\[\e[1;33m\])")\[\e[0m\]\$ '
		fi
	else
		export PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
	fi
	unset color_prompt
else
	if [ "$color_prompt" = yes ]; then
		if [ -n "$SSH_CLIENT" ]
		then
			if [ "$USER" = root ]; then
				export PS1='\[\e[1;36m\]\u\[\e[0;36m\](\h) \[\e[0;97m\]\w\[\e[0m\]$\$ '
			else
				export PS1='\[\e[1;35m\]\u\[\e[0;35m\](\h) \[\e[0;97m\]\w\[\e[0m\]$\$ '
			fi
		else
			export PS1='\[\e[1;36m\]\u \[\e[0;97m\]\w\[\e[0m\]\$ '
		fi
	else
		export PS1='\u@\h \W\$ '
	fi
	unset color_prompt
fi


# source /usr/share/git/completion/git-prompt.sh
# export GIT_PS1_SHOWDIRTYSTATE=1
# export PS1='\[\e[1;35m\]\u\[\e[0;35m\](\h) \[\e[0;97m\]\w\[\e[0m\]$(__git_ps1 " (%s)")\$ '

# Colour Aliases

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Autocomplete Settings

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
bind 'set completion-ignore-case on'

# Convenience Scripts

alias d=pwd
alias v=nvim
alias ab=autobuild
alias ssh-keygen-named="ssh-keygen -C $(whoami)@$(uname -n)-$(date -I)"
alias ds="du -hs * 2>/dev/null | sort -h"
alias nd=mkdir
alias nf=touch

# FZF Command

#export FZF_DEFAULT_COMMAND=''

# NNN Config

n () {
	if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
		echo "nnn is already running"
		return
	fi
	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
	nnn "$@"
	if [ -f "$NNN_TMPFILE" ]; then
		. "$NNN_TMPFILE"
		rm -f "$NNN_TMPFILE" > /dev/null
	fi
}

export NNN_OPTS="aARe"
export NNN_FIFO="/tmp/nnn.fifo"
export SPLIT="v"
export TERMINAL="tmux"
export NNN_USE_EDITOR=1
export NNN_OPENER="nuke"
export EDITOR="nvim"
export NNN_BMS="h:~/;r:/;d:~/Dev;o:~/Downloads;m:/run/media/$USER;s:/storage"
export NNN_PLUG='v:!nvim $nnn;p:preview-tui'
# export NNN_OPENER="/path/to/custom/opener" # Default opener template, to replace xdg-open
export LFS=/mnt/lfs

# Display colours

display-colours() {
for x in {0..8}; do
	for i in {30..37}; do
		for a in {40..47}; do
			echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
		done
		echo
	done
done
echo ""
}

colour-gradient() {
awk 'BEGIN{
s="/\\/\\/\\/\\/\\"; s=s s s s s s s s s s s s s s s s s s s s s s s;
for (colnum = 0; colnum<256; colnum++) {
	r = 255-(colnum*255/255);
	g = (colnum*510/255);
	b = (colnum*255/255);
	if (g>255) g = 510-g;
		printf "\033[48;2;%d;%d;%dm", r,g,b;
		printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
		printf "%s\033[0m", substr(s,colnum+1,1);
	}
	printf "\n";
}'
}

# Tmux on startup

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ -z $(ps -A | grep "tmux: client") ]] ; then
	exec tmux new -s "PID$$"
fi

# Run neofetch if this is the first terminal opened

# if [[  $(ps aux | grep -ic "$TERM") -lt 3 ]]
# then
# 	neofetch
# fi

