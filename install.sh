#!/usr/bin/bash

# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: install neovim and other bash, tmux and git condifurations.
# Last Modified: April 18, 2019

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
        if [[ "$sys_id" == *"centos"* ]]
        then
            pkg_manager="$SUDO yum"
            $pkg_manager install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
            $pkg_manager install -y python36
        elif [[ "$sys_id" == *"fedora"* ]]
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
    echo "export dotfiles_dir=$dotfiles_dir" >> $HOME/.bashrc
    source $HOME/.bashrc
    if [ -d $dotfiles_dir ]
    then
        rm -rf $dotfiles_dir
    fi
    mkdir -p $dotfiles_dir
    cd $dotfiles_dir
}

function update_bashrc() {
    echo_blue "** Bashrc update"
    echo "source $(echo $dotfiles_dir)/bash/bashrc" >> $HOME/.bashrc
}

function update_tmux_conf() {
    echo_blue "** Tmux config"
    echo "source $(echo $dotfiles_dir)/tmux/tmux.conf" >> $HOME/.tmux.conf
}

function update_git_conf() {
    echo_blue "** Git config"
    rm -rf $HOME/.config/git
    ln -s $dotfiles_dir/git $HOME/.config/git
}

function clone_repos() {
    cd $dotfiles_dir
    echo_blue "** Clone github repos -- $(pwd)"
    git clone -b 'dev' https://github.com/ammarnajjar/dotfiles.git .
    git clone https://github.com/ammarnajjar/wombat256mod.git plugged/wombat256mod
    git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git bash/bash-sensible
    git clone https://github.com/ammarnajjar/bash-git-prompt.git bash/bash-git-prompt
}

function nvim_symlinks() {
    echo_blue "** Create Neovim Symlinks"
    rm -rf $HOME/.config/nvim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s $dotfiles_dir $XDG_CONFIG_HOME/nvim
}

function install_plugins() {
    echo_blue "** Install plugins"
    nvim +PlugInstall +qall
}

function main(){
	get_sudo
	install_pkgs
	prepare_dotfiles_dir

    clone_repos
    nvim_symlinks

    update_tmux_conf
    update_git_conf
    update_bashrc
    source $HOME/.bashrc

    install_plugins
    echo_blue "** Installation Complete **"
}

current_dir=$(pwd)
main

# vim: set ft=sh ts=4 sw=4 et ai :
