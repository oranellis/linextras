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
[ -n "$colour_support" ] && colour_green_b="\[\033[1;32m\]" || colour_yellow_b=""
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

if [ -n "$SSH_CLIENT" ]
then
    ssh_hostname="yes"
elif [ -e "/.dockerenv" ]
then
    docker_hostname="yes"
fi

PS1=""
[ -n "$SSH_CLIENT" ] && PS1="$PS1$colour_purple_b" || PS1="$PS1$colour_cyan_b"
PS1="$PS1\u"
[ -n "$ssh_hostname" ] && PS1="$PS1(\h)"
[ -n "$docker_hostname" ] && PS1="$PS1$colour_green_b[\h]"
PS1="$PS1$colour_white \$(shorten_path)"
[ -n "$git_prompt_support" ] && PS1="$PS1\$( __git_ps1 \" $colour_yellow_b(%s$colour_yellow_b)\")"
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
alias nd=mkdir
alias nf=touch
ds() {
    returndir=$(pwd)
    if [ "$#" -gt "0" ]
    then
        if ! cd $@ &>/dev/null
        then
            echo "Bad directory argument" 1>&2
        fi
    fi
    du -hd 1 2>/dev/null | sort -h
    cd "$returndir"
}
dotfiles() {
    cd $(dirname $(readlink -f ~/.bashrc))
}
pacman-autoremove() {
sudo pacman -Rsu $(pacman -Qdtq)
}
dockerclean() {
    docker rm -f $(docker ps -aq)
}



# =============================
# === Dev Container Aliases ===
# =============================

dc() {
    local colour_green=$(tput setaf 10 2>/dev/null || echo '')
    local colour_red=$(tput setaf 9 2>/dev/null || echo '')
    local colour_normal=$(tput sgr0 2>/dev/null || echo '')

    echogreen() { echo "${colour_green}$*${colour_normal}"; }
    echored() { echo "${colour_red}$*${colour_normal}"; }
    echoerr() { echo "$@" 1>&2; }

    DC_SEARCH_FILE="devcontainer.json"

    dc_devcontainer_dir="$(pwd)"
    if git status &>/dev/null
    then
        dc_devcontainer_dir="$(git rev-parse --show-toplevel)"
    fi

    cd "$dc_devcontainer_dir" || { echoerr "Failed to change directory"; return 1; }

    if ! [ -d "./.devcontainer" ]
    then
        echoerr ".devcontainer directory not found"
        return 1
    fi

    dc_results=()
    readarray -d '' dc_results < <(find ./.devcontainer -maxdepth 2 -name "$DC_SEARCH_FILE" -print0)
    dc_results_count=${#dc_results[@]}

    if [ "$dc_results_count" -lt 1 ]
    then
        echoerr "No $DC_SEARCH_FILE found"
        return 1
    fi

    if [ "$dc_results_count" -gt 1 ]
    then
        echo "Found multiple devcontainers, select from below:"
        dc_index=1
        for f in "${dc_results[@]}"
        do
            echo -e "    $dc_index. $f"
            ((dc_index++))
        done

        echo -n "Enter the file number to use: "
        read dc_input

        if ! [[ "$dc_input" =~ ^[0-9]+$ ]]
        then
            echoerr "Not a valid number"
            return 1
        fi

        if [ "$dc_input" -lt 1 ] || [ "$dc_input" -gt "$dc_results_count" ]
        then
            echoerr "Number is out of bounds"
            return 1
        fi
        dc_selected_path="${dc_results[$((dc_input-1))]}"
    else
        dc_selected_path="${dc_results[0]}"
    fi

    if command -v devcontainer &>/dev/null
    then
        if ! devcontainer exec --workspace-folder . --config "$dc_selected_path" "/usr/bin/true" &>/dev/null
        then
            if devcontainer exec --workspace-folder . --config "$dc_selected_path" "/usr/bin/true" 2>&1 | grep -q "Dev container config (.*) not found."
            then
                echo "Dev container config not found"
                return 1
            fi

            echo -n "Building and starting dev container... "
            if devcontainer up --workspace-folder . --config "$dc_selected_path" &>/tmp/devcontainerbuild.log
            then
                echogreen "Done"
            else
                echored "Failed"
                echo "Log available at /tmp/devcontainerbuild.log"
                return 1
            fi

            echo ""
            echo "Installing dotfiles in dev container... "
            devcontainer exec --workspace-folder . --config "$dc_selected_path" /bin/bash -c "curl -s https://gist.githubusercontent.com/oranellis/aad91e319339612f20e77be423a701fd/raw/ | bash"
        fi
        devcontainer exec --workspace-folder . --config "$dc_selected_path" "bash"
    else
        echo "Devcontainer CLI tool not installed. Install with:"
        echo "npm install -g @devcontainers/cli"
        return 1
    fi
}



# ===================
# === Yazi Config ===
# ===================

n() {
    if ! command -v yazi &>/dev/null
    then
        (
        set -e
        [ "$(uname -m)" != "x86_64" ] && return 1 # Platform guard clause
        wget -O/tmp/yazi.zip https://github.com/sxyazi/yazi/releases/download/v0.3.3/yazi-x86_64-unknown-linux-gnu.zip
        unzip -o /tmp/yazi.zip -d /tmp/yazi/
        mkdir -p ~/.local/bin
        cp /tmp/yazi/*/yazi ~/.local/bin
        );
    else
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]
        then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    fi
}

export EDITOR="nvim"



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
