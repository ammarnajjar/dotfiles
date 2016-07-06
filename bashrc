alias up='sudo dnf update'
export TERM=xterm-256color
alias ll='ls -lh'
alias la='ls -aAh'
alias l='ls -CF'
HISTSIZE=1000
HISTFILESIZE=2000
function mkcd() { mkdir $1; cd $1; }
alias ctagsit="ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude='@.gitignore' --extra=q"
alias g="git status"
alias vi="vi -u NONE"
source $vim_dir/bash-sensible/sensible.bash
[[ $- = *i* ]] && source $vim_dir/liquidprompt/liquidprompt
[[ $- = *i* ]] && source $vim_dir/liquidprompt/liquid.theme
