
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
alias yt-dlp-audio='yt-dlp --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'

# don't put duplicate lines or lines starting with space in the history.
# HISTCONTROL=ignoreboth

# alias tmux='env TERM=screen-256color direnv exec $HOME tmux'
export TERM=xterm-256color
export LANG='en_US.UTF-8'
export EDITOR=nvim
export GIT_EDITOR="nvim"
export BAT_CONFIG_PATH=$dotfiles_dir/bat/config
export XDG_CONFIG_HOME="$HOME/.config"

# dotnet optout
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# get konsole profile name if possible
if hash qdbus 2>/dev/null; then
    export KONSOLE_PROFILE_NAME="$(qdbus $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_SESSION profile)"
fi

export GEM_HOME="$HOME/.gem"
export PATH="/usr/local/opt/ruby/bin:$HOME/.gem/bin:$PATH"
export PATH="$HOME/.npm-packages/bin:$PATH"

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

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
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'
--bind 'ctrl-v:execute(code {+})'
"
export FZF_DEFAULT_COMMAND="fd --exclude 'venv/*' --exclude 'coverage/*' --exclude 'node_modules/*' --exclude 'target/*' --exclude '__pycache__/*' --exclude 'dist/*' --exclude 'build/*' --exclude '*.DS_Store'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# asdf
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$dotfiles_dir/asdf/default-node-packages"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$dotfiles_dir/asdf/default-python-packages"
export ASDF_DIR="$dotfiles_dir/asdf/asdf"
export ASDF_DATA_DIR="$dotfiles_dir/asdf/asdf"
export ASDF_PLUGINS=(
    direnv
    dotnet-core
    fzf
    golang
    git
    nodejs
    python
    ruby
    rust
)

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=9999999999
export HISTSIZE=9999999999
export SAVEHIST=9999999999
export HISTTIMEFORMAT="[%F %T]: "

# useful functions stolen from https://github.com/Bash-it/bash-it
function mkcd() {
    mkdir -p -- "$*"
    cd -- "$*"
}

# fetch and reset hard the current branch
function gr()
{
    git fetch --prune
    git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
}

# update main and merge current branch to it locally
function gmm()
{
 branch="$(git rev-parse --abbrev-ref HEAD)"
 git fetch --prune
 git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
 git checkout main
 git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
 git checkout $branch
 git merge -S main
}

# update develop and merge current branch to it locally
function gmd()
{
 branch="$(git rev-parse --abbrev-ref HEAD)"
 git fetch --prune
 git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
 git checkout develop
 git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
 git checkout $branch
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


# TODO: maybe not needed anymore?
# # https://github.com/OmniSharp/omnisharp-vscode/issues/2970#issuecomment-541516806
# function set_dotnet_vars {
#   DOTNET_BASE=$(dotnet --info | grep "Base Path" | awk '{print $3}')
#   DOTNET_ROOT=$(echo $DOTNET_BASE | sed -E "s/^(.*)(\/sdk\/[^\/]+\/)$/\1/")
#   export MSBuildSDKsPath=${DOTNET_BASE}Sdks/
#   export DOTNET_ROOT=$DOTNET_ROOT
#   export PATH=$DOTNET_ROOT:$PATH
# }
# if command -v dotnet 1>/dev/null 2>&1; then
#     set_dotnet_vars
# fi

function asdf_add() {
    asdf plugin-add $1
    # for gpg-key issues see: https://github.com/asdf-vm/asdf-nodejs/issues/192#issuecomment-797448073
    asdf install $1 $2
    asdf global $1 $2
}

# update all asdf plugins to latest
# modified version of https://gist.github.com/ig0rsky/fef7f785b940d13b52eb1b379bd7438d
function asdf_update() {
    asdf plugin update --all

    cp ~/.tool-versions ~/.tool-versions.bk
    cat ~/.tool-versions | awk '{print $1}' | xargs -I {} bash -c 'asdf install {} $(asdf latest {}) && asdf global {} latest'

    echo "Version updates:"
    paste -d '\t' ~/.tool-versions ~/.tool-versions.bk
    rm ~/.tool-versions.bk
}

# https://github.com/asdf-community/asdf-direnv#pro-tips
PATH="$PATH:$ASDF_DIR/bin"

# vim: set ft=sh ts=4 sw=4 et ai :
