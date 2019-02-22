#!/usr/bin/bash

# File: install.sh
# Author: Ammar Najjar <najjarammar@gmail.com>
# Description: install vim/neovim and other bash, tmux and git condifurations.
# Last Modified: July 02, 2016

function usage() {
    echo "Install vim/neovim and configure its plugins with more into bash tmux and git configs"
    echo
    echo "Usage:"
    echo "    bash $0 [option]"
    echo "    Options:"
    echo "        -h --help                 : Show this help messaage."
    echo "        -b --build-from-source    : Build vim from source."
    echo "        -n --neovim               : Build neovim from source."
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

function install_build_dep(){
    get_current_distro
    if [[ $distro == "fedora" ]]
    then
        blue "** Install build denpendencies"
        $SU dnf install -y ncurses ncurses-devel \
            ruby ruby-devel lua lua-devel luajit \
            luajit-devel ctags git python python-devel \
            python3 python3-devel tcl-devel \
            perl perl-devel perl-ExtUtils-ParseXS \
            perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
            perl-ExtUtils-Embed python2-greenlet-devel
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
    blue "** Install denpendencies -- $(pwd)"
    if [[ $distro == "fedora" ]]
    then
        $SU dnf install -y git libtool autoconf automake cmake gcc gcc-c++ \
            make pkgconfig unzip python-pip redhat-rpm-config clang hostname \
            powerline kernel-devel python-devel the_silver_searcher ctags curl \
            wmctrl rxvt-unicode-256color
    elif [[ $distro == "debian" ]]
    then
        $SU apt-get update && $SU apt-get install -y curl \
            git libncurses5-dev libgnome2-dev libgnomeui-dev \
            libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
            libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
            python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev \
            silversearcher-ag exuberant-ctags clang powerline \
            build-essential libtool liblua5.1-dev luajit lua5.1 \
            wmctrl rxvt-unicode-256color
    elif [[ $distro == "ubuntu" ]]
    then
        $SU apt-get update && $SU apt-get install -y curl \
            git silversearcher-ag exuberant-ctags clang build-essential \
            automake python-dev python-pip python3-dev python3-pip libtool \
            wmctrl rxvt-unicode-256color
    fi
}

function build_vim_from_source() {
    install_build_dep
    blue "** Build vim from source in: $(pwd)"
    git clone https://github.com/vim/vim.git /tmp/vimsrc
    cd /tmp/vimsrc
    CFLAGS="-fPIC -g -Wall" ./configure \
        --with-features=huge            \
        --with-x=yes                    \
        --enable-acl                    \
        --enable-multibyte              \
        --enable-rubyinterp             \
        --enable-luainterp              \
        --enable-perlinterp             \
        --enable-pythoninterp           \
        --enable-tclinterp              \
        --enable-fontset                \
        --with-tlib=ncurses             \
        --enable-gui=auto               \
        --enable-cscope                 \
        --prefix=/usr/local
    make VIMRUNTIMEDIR="/usr/local/share/vim/vim74"
    $SU make install
}

function build_nvim_from_source() {
    get_sudo
    $SU pip install --upgrade pip
    $SU pip install neovim
    source_dir="/tmp/neovim_src"
    rm -rf $source_dir $HOME/.config/nvim
    mkdir -p $vim_dir/neobin
    git clone https://github.com/neovim/neovim.git $source_dir
    cd $source_dir
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$vim_dir/neobin"
    make install
}

function update_bashrc() {
    blue "** Bashrc update"
    echo "export PATH=\"$vim_dir/neobin/bin:$PATH\"" >> $HOME/.bashrc
    echo "source $(echo $vim_dir)/bash/bashrc" >> $HOME/.bashrc
}

function update_tmux_conf() {
    blue "** Tmux config"
    echo "source $(echo $vim_dir)/tmux/tmux.conf" >> $HOME/.tmux.conf
}

function update_git_conf() {
    blue "** Git config"
    ln -s $vim_dir/git/gitconfig $HOME/.config/git/config
    ln -s $vim_dir/git/gitmessage $HOME/.config/git/gitmessage
}

function clone_repos() {
    cd $vim_dir
    blue "** Clone github repos -- $(pwd)"
    git clone https://github.com/ammarnajjar/dotfiles.git .
    curl -fLo $vim_dir/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    git clone https://github.com/ammarnajjar/wombat256mod.git plugged/wombat256mod
    git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git
    git clone https://github.com/ammarnajjar/liquidprompt.git liquidprompt
}

function nvim_symlinks() {
    blue "** Create Neovim Symlinks"
    rm -rf $HOME/.nvim $HOME/.nvimrc
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s $vim_dir $XDG_CONFIG_HOME/nvim
    ln -s "$vim_dir/vimrc.vim" $XDG_CONFIG_HOME/nvim/init.vim
    # get_sudo
    # $SU rm /usr/local/bin/nvim
    # $SU ln -s "$vim_dir/neobin/bin/nvim" /usr/local/bin/nvim
}

function vim_symlinks() {
    blue "** Create vim Symlinks"
    rm -rf $HOME/.vim $HOME/.vimrc
    ln -s $vim_dir $HOME/.vim
    ln -s $vim_dir/vimrc.vim $HOME/.vimrc
}

function create_symlinks() {
    vim_symlinks
    if [[ $neo -eq 1 ]]
    then
        nvim_symlinks
    fi
    rm $HOME/.Xresources
    uname=$(uname -m)

    if [[ $distro == "debian" ]]
    then
        ln -s $vim_dir/urxvt/Xresources $HOME/.Xresources
        $SUDO ln -s $vimdir/urxvt/fullscreen /usr/lib/urxvt/perl/fullscreen
        $SUDO ln -s $vimdir/urxvt/resize-font /usr/lib/urxvt/perl/resize-font
        $SUDO ln -s $vimdir/urxvt/pasta /usr/lib/urxvt/perl/pasta
    else
        if [[ uname == "x86_64" ]]
        then
            ln -s $vim_dir/urxvt/Xresources $HOME/.Xresources
            $SUDO ln -s $vimdir/urxvt/fullscreen /usr/lib64/urxvt/perl/fullscreen
            $SUDO ln -s $vimdir/urxvt/resize-font /usr/lib64/urxvt/perl/resize-font
            $SUDO ln -s $vimdir/urxvt/pasta /usr/lib64/urxvt/perl/pasta
        else
            ln -s $vim_dir/urxvt/Xresources_i686 $HOME/.Xresources
            $SUDO ln -s $vimdir/urxvt/fullscreen /usr/lib/urxvt/perl/fullscreen
            $SUDO ln -s $vimdir/urxvt/resize-font /usr/lib/urxvt/perl/resize-font
            $SUDO ln -s $vimdir/urxvt/pasta /usr/lib/urxvt/perl/pasta
        fi
    fi
}

function prepare_vimdir() {
    cd $current_dir
    blue "** Preparing vimdir -- $(pwd)"
    vim_dir="$current_dir/dotfiles"
    echo "export vim_dir=$vim_dir" >> $HOME/.bashrc
    if [ -d $vim_dir ]
    then
        rm -rf $vim_dir
    fi
    mkdir -p $vim_dir
    cd $vim_dir
}

function install_plugins() {
    blue "** Install plugins"
    if [[ $neo -eq 0 ]]
    then
        vim +PlugInstall +qall
    else
        nvim +PlugInstall +qall
    fi
}

function main(){
    clone_repos
    create_symlinks

    update_tmux_conf
    update_git_conf
    update_bashrc
    source $HOME/.bashrc

    install_plugins
    blue "** Installation Complete **"
}

function build_from_source() {
    current_dir=$(pwd)
    get_sudo
    install_dep
    prepare_vimdir
    clone_repos
    if [[ $neo -eq 0 ]]
    then
        build_vim_from_source
    else
        build_nvim_from_source
    fi
    main
}

neo=0
if [[ $# -eq 0 ]]
then
    current_dir=$(pwd)
    get_sudo
    install_dep
    install_vim
    prepare_vimdir
    main
else
    case $1 in
        -h|--help)
            usage
            ;;
        -b|--build-from-source)
            build_from_source
            ;;
        -n|--neovim)
            neo=1
            build_from_source
            ;;
        *)
    esac
fi

# vim: set ft=sh ts=4 sw=4 et ai :
