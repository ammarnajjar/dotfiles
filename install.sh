# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: install neovim  and other bash/zsh, tmux and git condifurations.
# The old configurations if exist will be backed up under /tmp/trash/..
# Last Modified: Sat Feb 20 23:20:22 CET 2021

function echo_blue() {
    if [ ! -z $BASH_VERSION ]
    then
        echo -e '\E[37;44m'"\033[1m$1\033[0m"
    elif [ ! -z $ZSH_VERSION ]
    then
        print -P "%F{green}$1%f"
    fi
}

function get_sudo() {
    uid="$(id -u)"
    SUDO="sudo "
    if [[ $uid -eq 0 ]]
    then
        SUDO=""
    fi
}

function install_pkgs() {
    pkgs="git curl neovim tmux"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        sys_id="$(cat /etc/*release | grep ID=)"
        if [[ "$sys_id" == *"fedora"* ]]
        then
            pkg_manager="$SUDO"dnf
        elif [[ "$sys_id" == *"debian"* ]] || [[ "$sys_id" == *"Ubuntu"* ]]
        then
            pkg_manager="$SUDO"apt
        fi
        bash -c "$pkg_manager update && $pkg_manager install -y $pkgs"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        pkg_manager="brew"
        $pkg_manager install $pkgs
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "OS ("$OSTYPE") is not supported"
    else
        # not supported
        echo "OS ("$OSTYPE") is not supported"
    fi
}

function prepare_shell_rc_file() {
    cd $dotfiles_dir
    if [ ! -z $BASH_VERSION ]
    then
        echo_blue "=== bash ==="
        [ -f $HOME/.bashrc ] && mv $HOME/.bashrc /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_bashrc
        echo "export dotfiles_dir=$dotfiles_dir" > $HOME/.bashrc
        echo "source $dotfiles_dir/shell/bash/bashrc" >> $HOME/.bashrc
        git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git shell/bash/bash-sensible
        git clone https://github.com/ammarnajjar/bash-git-prompt.git shell/bash/bash-git-prompt
        shell="bash"
    elif [ ! -z $ZSH_VERSION ]
    then
        echo_blue "=== zsh ==="
        [ -f $HOME/.zshrc ] && mv $HOME/.zshrc /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_zshrc
        echo "export dotfiles_dir=$dotfiles_dir" > $HOME/.zshrc
        echo "source $dotfiles_dir/shell/zsh/zshrc" >> $HOME/.zshrc
        git clone https://github.com/ohmyzsh/ohmyzsh.git shell/zsh/ohmyzsh
        shell="zsh"
    fi
}

function prepare_dotfiles_dir() {
    cd $current_dir
    echo_blue "** Preparing dotfiles dir -- $(pwd)"
    dotfiles_dir="$current_dir/dotfiles"

    [ -d $dotfiles_dir ] && mv $dotfiles_dir /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_dotfiles
    mkdir -p $dotfiles_dir

    clone_dotfiles
}

function update_tmux_conf() {
    echo_blue "** Tmux config"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $HOME/.tmux.conf ] && rm $HOME/.tmux.conf
    [ -L $XDG_CONFIG_HOME/tmux ] && rm $XDG_CONFIG_HOME/tmux
    ln -s $dotfiles_dir/tmux $XDG_CONFIG_HOME/tmux
}

function clone_dotfiles() {
    cd $dotfiles_dir
    git clone https://github.com/ammarnajjar/dotfiles.git .
}

function clone_repos() {
    cd $dotfiles_dir
    echo_blue "** Clone github repos -- $(pwd)"
    curl -fLo autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    git clone https://github.com/ammarnajjar/vim-code-dark.git plugged/vim-code-dark.vim
    git clone https://github.com/asdf-vm/asdf.git asdf/asdf
}

function direnv_symlinks() {
    echo_blue "** Create direnv Symlinks"
    mkdir -p $HOME/.config/direnv
    ln -s $dotfiles_dir/direnv/direnvrc $HOME/.config/direnv/direnvrc
    ln -s $dotfiles_dir/direnv/envrc $HOME/.envrc
}

function vim_symlinks() {
    echo_blue "** Create Neovim/Vim Symlinks"
    [ -L $dotfiles_dir ] && mv $dotfiles_dir /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_dotfiles
    # neovim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $HOME/.config/nvim ] && rm $HOME/.config/nvim
    ln -s $dotfiles_dir $XDG_CONFIG_HOME/nvim
    # vim
    [ -L $HOME/.vim ] && rm $HOME/.vim
    [ -L $HOME/.vimrc ] && rm $HOME/.vimrc
    ln -s $dotfiles_dir $HOME/.vim
    ln -s $dotfiles_dir/init.vim $HOME/.vimrc
}

function compile_terminfo() {
    # enable italics in terminal
    tic -o $HOME/.terminfo $dotfiles_dir/shell/terminfo
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
    vim_symlinks
    direnv_symlinks
    compile_terminfo

    update_tmux_conf
    update_git_conf

    prepare_shell_rc_file
    install_plugins
    cd $HOME
    echo_blue "** Installation Complete **"
    exec $shell
}

current_dir=$(pwd)
main

# vim: set ft=sh ts=4 sw=4 et ai :
