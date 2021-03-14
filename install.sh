# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: install deps/repos and setup config files

function echo_blue() {
    if [ ! -z $BASH_VERSION ]
    then
        echo -e '\E[37;44m'"\033[1m$1\033[0m"
    elif [ ! -z $ZSH_VERSION ]
    then
        print -P "%F{green}$1%f"
    fi
}

function set_sudo() {
    uid="$(id -u)"
    SUDO="sudo "
    if [[ $uid -eq 0 ]]
    then
        SUDO=""
    fi
}

function install_pkgs() {
    pkgs="git curl tmux neovim"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        sys_id="$(cat /etc/*release | grep ID=)"
        if [[ "$sys_id" == *"fedora"* ]]
        then
            bash -c ""$SUDO"dnf install -y $pkgs findutils g++ ninja-build libstdc++-static"
        elif [[ "$sys_id" == *"debian"* ]] || [[ "$sys_id" == *"Ubuntu"* ]]
        then
            bash -c ""$SUDO"apt update && "$SUDO"apt install -y $pkgs findutils g++ ninja-build"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        brew install $pkgs ninja
    else
        # not supported
        echo "OS ("$OSTYPE") is not supported"
        exit 1
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

    [ -d $dotfiles_dir ] && mkdir -p /tmp/trash && mv $dotfiles_dir /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_dotfiles
    mkdir -p $dotfiles_dir && cd $dotfiles_dir
    git clone https://github.com/ammarnajjar/dotfiles.git .
}

function update_tmux_conf() {
    echo_blue "** Tmux config"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $HOME/.tmux.conf ] && rm $HOME/.tmux.conf
    [ -L $XDG_CONFIG_HOME/tmux ] && rm $XDG_CONFIG_HOME/tmux
    ln -s $dotfiles_dir/tmux $XDG_CONFIG_HOME/tmux
}

function asdf_setup() {
    cd $dotfiles_dir
    echo_blue "** asdf setup -- $(pwd)"
    git clone https://github.com/asdf-vm/asdf.git asdf/asdf
    ln -s $dotfiles_dir/asdf/default-cargo-crates $HOME/.default-cargo-crates
    ln -s $dotfiles_dir/asdf/default-gems $HOME/.default-gems

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "standard-resolver" > $HOME/.gnupg/dirmngr.conf
        "$SUDO"pkill dirmngr
    fi
}

function direnv_symlinks() {
    echo_blue "** Create direnv Symlinks"
    mkdir -p $HOME/.config/direnv
    ln -s $dotfiles_dir/direnv/direnvrc $HOME/.config/direnv/direnvrc
    ln -s $dotfiles_dir/direnv/envrc $HOME/.envrc
}

function nvim_symlinks() {
    [ -L $dotfiles_dir ] && mv $dotfiles_dir /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_dotfiles
    echo_blue "** Create Neovim Symlinks"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $HOME/.config/nvim ] && rm $HOME/.config/nvim
    ln -s $dotfiles_dir/nvim $XDG_CONFIG_HOME/nvim
}

function install_lua_language_server() {
    echo_blue "** lua language server "
    mkdir -p $dotfiles_dir/nvim/lsp
    cd $dotfiles_dir/nvim/lsp
    git clone https://github.com/sumneko/lua-language-server
    cd lua-language-server
    git submodule update --init --recursive
    cd 3rd/luamake
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        ninja -f ninja/linux.ninja
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ninja -f ninja/macos.ninja
    fi
    cd ../..
    ./3rd/luamake/luamake rebuild || echo "* Faild: installing lua-lsp-server"
}

function compile_terminfo() {
    # enable italics in terminal
    tic -o $HOME/.terminfo $dotfiles_dir/shell/terminfo
}

function update_git_conf() {
    echo_blue "** git config"
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    [ -L $XDG_CONFIG_HOME/git ] && mv $HOME/.config/git /tmp/trash/$(date "+%y-%m-%d_%H-%M-%S")_git
    ln -s $dotfiles_dir/git $XDG_CONFIG_HOME//git
}

function neovim_nightly() {
    if [ ! -z $BASH_VERSION ]
    then
        bash --rcfile <(echo '. ~/.bashrc; asdf_add neovim nightly; exit')
        bash --rcfile <(echo '. ~/.bashrc; nvim +PackerCompile +PackerInstall; exit')
    elif [ ! -z $ZSH_VERSION ]
    then
        zsh -c '. ~/.zshrc; asdf_add neovim nightly; exit'
        zsh -c '. ~/.zshrc; nvim +PackerCompile +PackerInstall; exit'
    fi
}

function main(){
    set_sudo
    install_pkgs
    prepare_dotfiles_dir

    asdf_setup
    nvim_symlinks
    direnv_symlinks
    compile_terminfo

    update_tmux_conf
    update_git_conf

    prepare_shell_rc_file
    install_lua_language_server
    neovim_nightly
    cd $current_dir
    echo_blue "** Installation Complete **"
    exec $shell
}

current_dir=$(pwd)
main

# vim: set ft=sh ts=4 sw=4 et ai :
