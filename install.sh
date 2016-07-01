#!/usr/bin/bash

# File: install.sh
# Author: Ammar Najjar <najjarammar@gmail.com>
# Description: install vim and other bash, tmux and git condifurations.
# Last Modified: July 01, 2016

usage() {
    echo "Install vim and configure its plugins with more into bash tmux and git configs"
    echo
    echo "Usage:"
    echo "    bash $0 [option]"
    echo "    Options:"
    echo "        -b --build-from-source: Build vim from source."
    echo "        -h --help             : Show this help messaage."
}

function get_sudo() {
    uid="$(id -u)"
    SU="sudo"
    if [[ $uid -eq 0 ]]
    then
        SU=""
    fi
}

function blue() {
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

function get_current_distro() {
    sys_id="$(cat /etc/*release | grep ID=)"
    if [[ "$sys_id" == *"fedora"* ]]
    then
        distro="fedora"
    elif [[ "$sys_id" == *"debian"* ]]
    then
        distro="debian"
    elif [[ "$sys_id" == *"ubuntu"* ]]
    then
        distro="ubuntu"
    fi
}

function install_vim() {
    get_current_distro
    if [[ $distro = "fedora" ]]
    then
        $SU dnf install -y vim vim-x11
    elif [[ $distro = "debian" ]]
    then
        $SU apt-get install -y vim vim-gtk
    elif [[ $distro = "ubuntu" ]]
    then
        $SU apt-get install -y vim vim-gtk
    fi
}

function build_from_source() {
    install_buil_dep
    blue "** Build vim from source"
    git clone https://github.com/vim/vim.git /tmp/vimsrc
    cd /tmp/vimsrc
    blue "** Working in $(pwd)"
    CFLAGS+="-O -fPIC -Wformat" ./configure --with-features=huge \
        --enable-multibyte                                       \
        --enable-rubyinterp                                      \
        --enable-python3interp                                   \
        --with-python3-config-dir=/usr/lib/python3.5/config      \
        --enable-perlinterp                                      \
        --enable-luainterp                                       \
        --enable-gui=auto                                        \
        --enable-cscope                                          \
        --prefix=/usr/local                                      \
        make VIMRUNTIMEDIR="/usr/local/share/vim/vim74"
    $SU make install
}

function install_buil_dep(){
    get_current_distro
    if [[ $distro == "fedora" ]]
    then
        blue "** Install build denpendencies"
        $SU dnf install -y ncurses ncurses-devel hostname \
            ruby ruby-devel lua lua-devel luajit \
            luajit-devel ctags git python python-devel \
            python3 python3-devel tcl-devel \
            perl perl-devel perl-ExtUtils-ParseXS \
            perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
            perl-ExtUtils-Embed
    elif [[ $distro == "ubuntu" ]]
    then
        blue "** Install build denpendencies"
        $SU apt-get update && $SU apt-get install -y \
            libncurses5-dev libgnome2-dev libgnomeui-dev \
            libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
            libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
            ruby-dev
    fi
}

function install_dep(){
    get_current_distro
    blue "Distro = $distro"
    blue "** Install denpendencies"
    if [[ $distro == "fedora" ]]
    then
        $SU dnf install -y git libtool autoconf automake cmake gcc gcc-c++ \
            make pkgconfig unzip python-pip redhat-rpm-config clang \
            powerline kernel-devel python-devel the_silver_searcher ctags
        echo "source '/usr/share/tmux/powerline.conf'" >> $HOME/.tmux.conf
    elif [[ $distro == "debian" ]]
    then
        $SU apt-get update && $SU apt-get install -y \
            git silversearcher-ag exuberant-ctags clang powerline \
            build-essential libtool liblua5.1-dev luajit lua5.1
        echo "source '/usr/share/powerline/bindings/tmux/powerline.conf'" >> $HOME/.tmux.conf
    elif [[ $distro == "ubuntu" ]]
    then
        $SU apt-get update && $SU apt-get install -y \
            git silversearcher-ag exuberant-ctags clang build-essential \
            automake python-dev python-pip python3-dev python3-pip libtool
    fi
}

function update_bashrc() {
    blue "** Bashrc update"
    echo 'source ~/.vim/bashrc' >> $HOME/.bashrc
}

function update_tmux_conf() {
    blue "** Tmux config"
    echo "set -g history-limit 1000000" >> $HOME/.tmux.conf
    echo "set -s escape-time 0" >> $HOME/.tmux.conf
}

function update_git_conf() {
    blue "** Git config"
    git config --global alias.lol 'log --graph --decorate --pretty=oneline --abbrev-commit --all'
    git config --global alias.st 'status'
}

function clone_repos() {
    blue "** Clone github repos"
    git clone https://github.com/ammarnajjar/dotfiles.git .
    git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
    git clone https://github.com/ammarnajjar/wombat256mod.git bundle/wombat256mod
    # bash-sensible && liquid prompt (my forks)
    git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git
    git clone -b twolinedprompt https://github.com/ammarnajjar/liquidprompt.git liquidprompt
}

function create_symlinks() {
    blue "** Create Symlinks"
    rm -rf $HOME/.vim $HOME/.vimrc $HOME/.Xresources
    ln -s $vim_dir $HOME/.vim
    ln -s $vim_dir/vimrc.vim $HOME/.vimrc
    ln -s $vim_dir/Xresources $HOME/.Xresources
}

function prepare_vimdir() {
    blue "** Preparing vimdir"
    current_dir=$(pwd)
    vim_dir="$current_dir/dotfiles"
    if [ -d $vim_dir ]
    then
        rm -rf $vim_dir
    fi
    mkdir -p $vim_dir
}

function install_plugins() {
    blue "** Install vim plugins"
    vim +PluginInstall +qall
}

function main(){
    prepare_vimdir
    cd $vim_dir

    clone_repos
    update_tmux_conf
    update_git_conf
    update_bashrc

    create_symlinks
    install_plugins
    source $HOME/.bashrc
    blue "** Installation Complete **"
}


if [[ $# -eq 0 ]]
then
    get_sudo
    install_dep
    install_vim
    main
else
    case $1 in
        -h|--help)
            usage
            ;;
        -b|--build-from-source)
            get_sudo
            install_dep
            build_from_source
            main
            ;;
        *)
    esac
fi

# vim: set ft=sh ts=4 sw=4 et ai :
