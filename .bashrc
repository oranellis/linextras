#         ____
#        / __ \_______ ____  ___
#       / /_/ / __/ _ `/ _ \(_-<
#       \____/_/  \_,_/_//_/___/
#     ____             __    ____  ______
#    / __ )____ ______/ /_  / __ \/ ____/
#   / __  / __ `/ ___/ __ \/ /_/ / /
#  / /_/ / /_/ (__  ) / / / _, _/ /___
# /_____/\__,_/____/_/ /_/_/ |_|\____/

# If not running interactively, don't do anything

[[ $- != *i* ]] && return



# ================
# === Env vars ===
# ================

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
command -v manpath >/dev/null && \
	export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export DOCKER_BUILDKIT=1
export SPLIT="v"
export LFS="/mnt/lfs"



# ========================
# === Source Env Files ===
# ========================

. "$HOME/.cargo/env" 2>/dev/null
. "$HOME/.keys" 2>/dev/null



# ========================
# === History Settings ===
# ========================

HISTCONTROL=ignoreboth
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000
HISTFILESIZE=2000



# ==========================================
# === Update window size on command exec ===
# ==========================================

[[ $DISPLAY ]] && shopt -s checkwinsize



# =====================================
# === Add SSH password to ssh-agent ===
# =====================================

start-ssh-agent() {
	mkdir -p "$HOME/.config" &>/dev/null
	ssh_pid_file="$HOME/.config/ssh-agent.pid"
	SSH_AUTH_SOCK="$HOME/.config/ssh-agent.sock"
	if [ -z "$SSH_AGENT_PID" ]
	then
		SSH_AGENT_PID=$(cat "$ssh_pid_file")
	fi

	if ! kill -0 $SSH_AGENT_PID &> /dev/null
	then
		rm "$SSH_AUTH_SOCK" &> /dev/null
		eval "$(ssh-agent -s -a "$SSH_AUTH_SOCK")"
		echo "$SSH_AGENT_PID" > "$ssh_pid_file"
		ssh-add 2>/dev/null
	fi
	export SSH_AGENT_PID
	export SSH_AUTH_SOCK
}

command -v ssh-agent >/dev/null && \
	command -v ssh-add >/dev/null && \
	start-ssh-agent



# =================
# === PS1 setup ===
# =================

[ -e "/usr/share/git/git-prompt.sh" ] && . "/usr/share/git/git-prompt.sh"
[ -e "/usr/lib/git-core/git-sh-prompt" ] && . "/usr/lib/git-core/git-sh-prompt"
command -v __git_ps1 >/dev/null 2>&1 && {
	git_prompt_support="y"
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWCOLORHINTS=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWUPSTREAM="auto"
	export GIT_PS1_DESCRIBE_STYLE="branch"
}
[ -x /usr/bin/tput ] && tput setaf 1 >/dev/null 2>&1 && colour_support="y"

[ -n "$colour_support" ] && colour_cyan_b="\[\033[1;36m\]" || colour_cyan_b=""
[ -n "$colour_support" ] && colour_cyan="\[\033[0;36m\]" || colour_cyan=""
[ -n "$colour_support" ] && colour_purple_b="\[\033[1;35m\]" || colour_purple_b=""
[ -n "$colour_support" ] && colour_purple="\[\033[0;35m\]" || colour_purple=""
[ -n "$colour_support" ] && colour_yellow_b="\[\033[1;33m\]" || colour_yellow_b=""
[ -n "$colour_support" ] && colour_white="\[\033[0;97m\]" || colour_white=""
[ -n "$colour_support" ] && colour_normal="\[\033[0m\]" || colour_normal=""

shorten_path() {
    local path="${PWD/#$HOME/\~}"
    if [ "${#path}" -le 30 ]; then
        echo "$path"
        return
    fi
    local IFS='/'
    read -ra ADDR <<< "$path"
    local short_path=""
    for ((i=0; i<${#ADDR[@]}-1; i++)); do
        if [[ ${ADDR[i]} ]]; then
            [[ "${ADDR[i]}" == "" ]] && short_path+="/" || short_path+="${ADDR[i]:0:3}/"
        fi
    done
    short_path+="${ADDR[-1]}"
    echo "$short_path"
}

if [ -e "/.dockerenv" ] || [ -n "$SSH_CLIENT" ]
then
	show_hostname="yes"
fi

PS1=""
[ -n "$SSH_CLIENT" ] && \
	PS1="$PS1$colour_purple_b" || \
	PS1="$PS1$colour_cyan_b"
PS1="$PS1\u"
[ -n "$show_hostname" ] && \
	PS1="$PS1(\h)"
PS1="$PS1$colour_white \$(shorten_path)"
[ -n "$git_prompt_support" ] && \
	PS1="$PS1\$( __git_ps1 \" $colour_yellow_b(%s$colour_yellow_b)\")"
PS1="$PS1$colour_normal\\$ "

export PS1



# ======================
# === Colour Aliases ===
# ======================

alias ls='ls --color=auto'
alias grep='grep --color=auto'



# =============================
# === Autocomplete Settings ===
# =============================

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
bind 'set completion-ignore-case on'



# ===========================
# === Convenience Aliases ===
# ===========================

alias ab=autobuild
alias ssh-keygen-named="ssh-keygen -t ed25519 -a 100 -C $(whoami)@$(uname -n)-$(date -I)"
alias ds="du -hd 1 2>/dev/null | sort -h"
alias nd=mkdir
alias nf=touch



# ==================
# === NNN Config ===
# ==================

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
export TERMINAL="tmux"
export NNN_USE_EDITOR=1
export EDITOR="nvim"
export NNN_BMS="h:~/;r:/;d:~/Dev;o:~/Downloads;m:/run/media/$USER;s:/storage"
export NNN_PLUG='v:!nvim $nnn;p:preview-tui'

nn() {
	cd && cd $(find . -type d 2>/dev/null | fzf) && n
}



# =======================
# === Display colours ===
# =======================

colour-table() {
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



# =======================
# === Tmux on startup ===
# =======================

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ] && [[ -z $(ps -A | grep "tmux: client") ]]
then
	if [ -n "$SSH_CLIENT" ]
	then
		exec tmux -f "$HOME/.tmux.ssh.conf" new -s "PID$$"
	else
		exec tmux new -s "PID$$"
	fi
fi
