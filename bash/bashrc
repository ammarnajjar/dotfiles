alias up='sudo dnf update'
export TERM=xterm-256color
alias ll='ls -lh'
alias la='ls -aAh'
alias l='ls -CF'
HISTSIZE=100000
HISTFILESIZE=2000
alias ctagsit="ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude='@.gitignore' --extra=q"
alias g="git status"
alias vi="vi -u NONE"
source $vim_dir/bash-sensible/sensible.bash
[[ $- = *i* ]] && source $vim_dir/liquidprompt/liquidprompt
[[ $- = *i* ]] && source $vim_dir/liquidprompt/liquid.theme
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
