
alias ll='ls -lh'
alias la='ls -aAh'
alias l='ls -CF'
alias g="git status"

# Tell grep to highlight matches
alias grep="grep --color=auto"
alias fgrep="grep -F --color=auto"
alias egrep="grep -E --color=auto"

# typo
alias gti=git
alias dokcer=docker

alias yt-dlp-audio='yt-dlp --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
export TERM=xterm-256color
export LANG='en_US.UTF-8'
export EDITOR=nvim
export GIT_EDITOR="nvim"
export BAT_CONFIG_PATH=$dotfiles_dir/bat/config
export XDG_CONFIG_HOME="$HOME/.config"

# get konsole profile name if possible
if hash qdbus 2>/dev/null; then
    export KONSOLE_PROFILE_NAME="$(qdbus $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_SESSION profile)"
fi

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# clipboard command (used by fzf ctrl-y bind)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export COPY_CMD=pbcopy
elif command -v xclip &>/dev/null; then
    export COPY_CMD="xclip -selection clipboard"
elif command -v wl-copy &>/dev/null; then
    export COPY_CMD=wl-copy
fi

# fzf
export FZF_DEFAULT_OPTS="
--border
--info=inline
--height=80%
--multi
--preview-window=:hidden
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | ${COPY_CMD:-pbcopy})'
--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
--bind 'ctrl-v:execute(code {+})'
"
export FZF_DEFAULT_COMMAND="fd --exclude 'venv/*' --exclude 'coverage/*' --exclude 'node_modules/*' --exclude 'target/*' --exclude '__pycache__/*' --exclude 'dist/*' --exclude 'build/*' --exclude '*.DS_Store'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export HISTSIZE=9999999999

# useful functions stolen from https://github.com/Bash-it/bash-it
function mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

# fetch and reset hard the current branch
function gr() {
    git fetch --prune
    git reset --hard "origin/$(git rev-parse --abbrev-ref HEAD)"
}

# update main and merge current branch to it locally
function gmm() {
    local branch
    branch="$(git rev-parse --abbrev-ref HEAD)"
    git fetch --prune
    git reset --hard "origin/$branch"
    git checkout main
    git reset --hard "origin/main"
    git checkout "$branch"
    git merge -S main
}

# update develop and merge current branch to it locally
function gmd() {
    local branch
    branch="$(git rev-parse --abbrev-ref HEAD)"
    git fetch --prune
    git reset --hard "origin/$branch"
    git checkout develop
    git reset --hard "origin/develop"
    git checkout "$branch"
    git merge -S develop
}

# display all ip addresses for this host
function ips ()
{
    if command -v ifconfig &>/dev/null
    then
        ifconfig | awk '/inet /{ print $2 }'
    elif command -v ip &>/dev/null
    then
        ip addr | grep -oP 'inet \K[\d.]+'
    else
        echo "You don't have ifconfig or ip command installed!"
    fi
}

# back up file with timestamp
function bak ()
{
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp -a "${filename}" "${filename}_${filetime}"
}

# move files to hidden folder in /tmp/.trash
function del() {
    mkdir -p /tmp/.trash && mv "$@" /tmp/.trash;
}

# vim: set ft=sh ts=4 sw=4 et ai :
