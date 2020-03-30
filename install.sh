#!/usr/bin/bash

# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: install neovim and other bash, tmux and git condifurations.
# The old configurations if exist will be backed up under /tmp/trash/..
# Last Modified: April 21, 2019

function echo_blue() {
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

function get_sudo() {
    uid="$(id -u)"
    SUDO="sudo"
    if [[ $uid -eq 0 ]]
    then
        SUDO=""
    fi
}

function install_pkgs() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        sys_id="$(cat /etc/*release | grep ID=)"
        if [[ "$sys_id" == *"fedora"* ]]
        then
            pkg_manager="$SUDO dnf"
            $pkg_manager install -y python{2,3}-neovim
        elif [[ "$sys_id" == *"debian"* ]]
        then
            pkg_manager="$SUDO apt-get"
            $pkg_manager install -y python-neovim python3-neovim
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        pkg_manager="brew"
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "OS ("$OSTYPE") is not supported"
    else
        # not supported
        echo "OS ("$OSTYPE") is not supported"
    fi
    pkgs="git curl wget tmux neovim"
    $pkg_manager install -y $pkgs
}

function prepare_dotfiles_dir() {
    cd $current_dir
    echo_blue "** Preparing dotfiles dir -- $(pwd)"
    dotfiles_dir="$current_dir/dotfiles"
    [ -f $HOME/.bashrc ] && mv $HOME/.bashrc /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_bashrc
    echo "export dotfiles_dir=$dotfiles_dir" > $HOME/.bashrc
    echo "source $(echo $dotfiles_dir)/bash/bashrc" >> $HOME/.bashrc
    source $HOME/.bashrc
    [ -d $dotfiles_dir ] && mv $dotfiles_dir /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_dotfiles
    mkdir -p $dotfiles_dir
    cd $dotfiles_dir
}

function update_tmux_conf() {
    echo_blue "** Tmux config"
    [ -L $HOME/.tmux.conf ] && mv $HOME/.tmux.conf /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_tmux.conf
    ln -s $dotfiles_dir/tmux/tmux.conf $HOME/.tmux.conf
}

function clone_repos() {
    cd $dotfiles_dir
    echo_blue "** Clone github repos -- $(pwd)"
    git clone https://github.com/ammarnajjar/dotfiles.git .
    git clone https://github.com/ammarnajjar/vim-code-dark.git plugged/vim-code-dark.vim
    git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git bash/bash-sensible
    git clone https://github.com/ammarnajjar/bash-git-prompt.git bash/bash-git-prompt
}

function nvim_symlinks() {
    echo_blue "** Create Neovim Symlinks"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $HOME/.config/nvim ] && mv $HOME/.config/nvim /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_nvim
    ln -s $dotfiles_dir $XDG_CONFIG_HOME/nvim
}

function update_git_conf() {
    echo_blue "** Git config"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $XDG_CONFIG_HOME/git ] && mv $HOME/.config/git /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_git
    ln -s $dotfiles_dir/git $XDG_CONFIG_HOME//git
}


function install_plugins() {
    echo_blue "** Install plugins"
    nvim +PlugInstall +qall
}

function main(){
    mkdir -p /tmp/trash
    get_sudo
    install_pkgs
    prepare_dotfiles_dir

    clone_repos
    nvim_symlinks

    update_tmux_conf
    update_git_conf
    source $HOME/.bashrc

    install_plugins
    echo_blue "** Installation Complete **"
}

current_dir=$(pwd)
main

# vim: set ft=sh ts=4 sw=4 et ai :
