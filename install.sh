#!/usr/bin/bash

# File: install.sh
# Author: Ammar Najjar <najjarammar@gmail.com>
# Description: install neovim and other bash, tmux and git condifurations.
# Last Modified: June 19, 2018

function blue() {
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

function get_sudo() {
    uid="$(id -u)"
    SU="sudo"
    if [[ $uid -eq 0 ]]
    then
        SU=""
    fi
}

function get_current_distro() {
    sys_id="$(cat /etc/*release | grep ID=)"
    if [[ "$sys_id" == *"fedora"* ]]
    then
        distro="fedora"
    elif [[ "$sys_id" == *"debian"* ]]
    then
        distro="debian"
    fi
}

function install_neovim() {
    get_current_distro
    nvim="neovim python3-neovim python-neovim"
    if [[ $distro = "fedora" ]]
    then
        $SU dnf install -y $nvim
    elif [[ $distro = "debian" ]]
    then
        $SU apt-get install -y $nvim
    fi
}

function update_bashrc() {
    blue "** Bashrc update"
    echo "source $(echo $dotfiles_dir)/bash/bashrc" >> $HOME/.bashrc
}

function update_tmux_conf() {
    blue "** Tmux config"
    echo "source $(echo $dotfiles_dir)/tmux/tmux.conf" >> $HOME/.tmux.conf
}

function update_git_conf() {
    blue "** Git config"
    ln -s $vim_dir/git/gitconfig $HOME/.config/git/config
    ln -s $vim_dir/git/gitmessage $HOME/.config/git/gitmessage
}

function clone_repos() {
    cd $dotfiles_dir
    blue "** Clone github repos -- $(pwd)"
    git clone -b 'neovim' https://github.com/ammarnajjar/dotfiles.git .
    git clone https://github.com/ammarnajjar/wombat256mod.git plugged/wombat256mod
    git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git
    git clone https://github.com/ammarnajjar/liquidprompt.git liquidprompt
}

function nvim_symlinks() {
    blue "** Create Neovim Symlinks"
    rm -rf $HOME/.config/nvim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s $dotfiles_dir $XDG_CONFIG_HOME/nvim
}

function prepare_dotfiles_dir() {
    cd $current_dir
    blue "** Preparing dotfiles dir -- $(pwd)"
    dotfiles_dir="$current_dir/dotfiles"
    echo "export dotfiles_dir=$dotfiles_dir" >> $HOME/.bashrc
    if [ -d $dotfiles_dir ]
    then
        rm -rf $dotfiles_dir
    fi
    mkdir -p $dotfiles_dir
    cd $dotfiles_dir
}

function install_plugins() {
    blue "** Install plugins"
    nvim +PlugInstall +qall
}

function main(){
    clone_repos
    nvim_symlinks

    update_tmux_conf
    update_git_conf
    update_bashrc
    source $HOME/.bashrc

    install_plugins
    blue "** Installation Complete **"
}

current_dir=$(pwd)
get_sudo
install_neovim
prepare_dotfiles_dir
main

# vim: set ft=sh ts=4 sw=4 et ai :
