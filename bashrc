HISTSIZE=10000
HISTFILESIZE=20000
export TERM=xterm-256color
alias up='sudo dnf update'
alias ll='ls -lh'
alias la='ls -aAh'
alias l='ls -CF'
alias ctagsit="ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude='@.gitignore' --extra=q"
alias g="git status"
function mkcd() { mkdir $1; cd $1; }
source ~/.vim/bash-sensible/sensible.bash
[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquidprompt
[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquid.theme
