# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: install deps/repos and setup config files

function echo_blue() {
    if [ -n "$BASH_VERSION" ]; then
        echo -e '\E[37;44m'"\033[1m$1\033[0m"
    elif [ -n "$ZSH_VERSION" ]; then
        print -P "%F{green}$1%f"
    fi
}

function set_sudo() {
    uid="$(id -u)"
    SUDO="sudo"
    if [[ $uid -eq 0 ]]; then
        SUDO=""
    fi
}

function install_pkgs() {
    pkgs="git curl tmux neovim"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        sys_id="$(cat /etc/*release | grep ID=)"
        if [[ "$sys_id" == *"fedora"* ]]; then
            bash -c "$SUDO dnf install -y $pkgs findutils g++ ninja-build libstdc++-static"
        elif [[ "$sys_id" == *"debian"* ]] || [[ "$sys_id" == *"Ubuntu"* ]]; then
            bash -c "$SUDO apt update && $SUDO apt install -y $pkgs findutils g++ ninja-build"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        brew install "$pkgs" ninja
    else
        # not supported
        echo "OS ($OSTYPE) is not supported"
        exit 1
    fi
}

function prepare_shell_rc_file() {
    cd "$dotfiles_dir" || return
    if [[ -n $BASH_VERSION ]]; then
        echo_blue "=== bash ==="
        shell="bash"
        [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_bashrc"
        echo "export dotfiles_dir=$dotfiles_dir" >"$HOME/.bashrc"
        echo "source $dotfiles_dir/shell/bash/bashrc" >>"$HOME/.bashrc"
        git clone --depth=1 -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git shell/bash/bash-sensible
    elif [[ -n "$ZSH_VERSION" ]]; then
        echo_blue "=== zsh ==="
        shell="zsh"
        [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_zshrc"
        echo "export dotfiles_dir=$dotfiles_dir" >"$HOME/.zshrc"
        echo "source $dotfiles_dir/shell/zsh/zshrc" >>"$HOME/.zshrc"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dotfiles_dir/shell/zsh/powerlevel10k"
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$dotfiles_dir/shell/zsh/zsh-syntax-highlighting"
        ln -s "$dotfiles_dir/shell/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    fi
}

function prepare_dotfiles_dir() {
    cd "$current_dir" || return
    echo_blue "** Preparing dotfiles dir -- $(pwd)"
    dotfiles_dir="$current_dir/dotfiles"

    [ -d "$dotfiles_dir" ] && mkdir -p /tmp/trash && mv "$dotfiles_dir" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_dotfiles"
    mkdir -p "$dotfiles_dir" && cd "$dotfiles_dir" || return
    git clone --depth=1 https://github.com/ammarnajjar/dotfiles.git .
}

function update_tmux_conf() {
    echo_blue "** Tmux config"
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
    [ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf"
    [ -L "$XDG_CONFIG_HOME/tmux" ] && rm "$XDG_CONFIG_HOME/tmux"
    ln -s "$dotfiles_dir/tmux" "$XDG_CONFIG_HOME/tmux"
}

function mise_setup() {
    echo_blue "** mise setup -- $(pwd)"
    ln -s "$dotfiles_dir/mise/default-cargo-crates" "$HOME/.default-cargo-crates"
    ln -s "$dotfiles_dir/mise/default-gems" "$HOME/.default-gems"
    ln -s "$dotfiles_dir/mise/default-python-packages" "$HOME/.default-python-packages"
    ln -s "$dotfiles_dir/mise/default-node-packages" "$HOME/.default-node-packages"
}

function nvim_symlinks() {
    [ -L "$dotfiles_dir" ] && mv "$dotfiles_dir" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_dotfiles"
    echo_blue "** Create Neovim Symlinks"
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
    [ -L "$HOME/.config/nvim" ] && rm "$HOME/.config/nvim"
    ln -s "$dotfiles_dir/nvim" "$XDG_CONFIG_HOME/nvim"
}

function compile_terminfo() {
    # enable italics in terminal
    tic -o "$HOME/.terminfo" "$dotfiles_dir/shell/terminfo"
}

function update_git_conf() {
    echo_blue "** git config"
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
    [ -L "$XDG_CONFIG_HOME/git" ] && mv "$HOME/.config/git" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_git"
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O "$dotfiles_dir/git/git-completion.bash"
    ln -s "$dotfiles_dir/git" "$XDG_CONFIG_HOME//git"
}

function main() {
    set_sudo
    install_pkgs
    prepare_dotfiles_dir

    mise_setup
    nvim_symlinks
    compile_terminfo

    update_tmux_conf
    update_git_conf

    prepare_shell_rc_file
    cd "$current_dir" || return
    echo_blue "** Installation Complete **"
    exec $shell
}

current_dir=$(pwd)
main

# vim: set ft=sh ts=4 sw=4 et ai :
