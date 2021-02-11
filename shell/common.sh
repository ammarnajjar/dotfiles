alias ll='ls -lh'
alias la='ls -aAh'
alias l='ls -CF'
alias g="git status"

# Tell grep to highlight matches
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# typo
alias gti=git
alias dokcer=docker

alias ctagsit="ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude='@.gitignore' --extra=q"

# don't put duplicate lines or lines starting with space in the history.
# HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it

export TERM=xterm-256color
export LANG='en_US.UTF-8'
export EDITOR=vim
export GIT_EDITOR="vim"

# optout
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# get konsole profile name if possible
if hash qdbus 2>/dev/null; then
    export KONSOLE_PROFILE_NAME="$(qdbus $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_SESSION profile)"
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=
export HISTSIZE=
export SAVEHIST=
export HISTTIMEFORMAT="[%F %T]: "

export GEM_HOME="$HOME/.gem"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

if command -v manpath 1>/dev/null 2>&1; then
    unset MANPATH # delete if you already modified MANPATH elsewhere in your config
    export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi

export FZF_DEFAULT_OPTS='--height 60% --border'

# asdf
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$dotfiles_dir/asdf/default-node-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$dotfiles_dir/asdf/default-python-packages"
export ASDF_DIR="$dotfiles_dir/asdf/asdf"
export ASDF_DATA_DIR="$dotfiles_dir/asdf/asdf"
export ASDF_PLUGINS=(
    direnv
    nodejs
    python
    dotnet-core
)

# useful functions stolen from https://github.com/Bash-it/bash-it
function mkcd() {
    mkdir -p -- "$*"
    cd -- "$*"
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
# search through directory contents with grep
function lsgrep ()
{
    ls | grep "$*"
}
# back up file with timestamp
function buf ()
{
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp -a "${filename}" "${filename}_${filetime}"
}
# move files to hidden folder in /tmp/.trash
function del() {
    mkdir -p /tmp/.trash && mv "$@" /tmp/.trash;
}

function reset_branch() {
    git reset --hard $(git rev-parse --abbrev-ref HEAD)
}

function set_to_origin() {
    git fetch && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
}

# vim: set ft=sh ts=4 sw=4 et ai :
