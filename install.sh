#!/usr/bin/env bash
set -euo pipefail

# File: install.sh
# Author: Ammar Najjar <najjarammar@protonmail.com>
# Description: Bootstrap a fresh machine with dotfiles

readonly DOTFILES_REPO="https://github.com/ammarnajjar/dotfiles.git"

function echo_blue() {
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

function backup() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p /tmp/trash
        mv "$target" "/tmp/trash/$(date '+%y-%m-%d_%H-%M-%S')_$(basename "$target")"
    fi
}

function detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            echo "${ID:-linux}"
        else
            echo "linux"
        fi
    else
        echo "unsupported"
    fi
}

function install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo_blue "** Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
    fi
}

function install_pkgs() {
    local os
    os=$(detect_os)
    echo_blue "** Installing packages (OS: $os)"

    local common_pkgs=(git curl tmux neovim)

    case "$os" in
        macos)
            install_homebrew
            brew install "${common_pkgs[@]}" ninja tree-sitter-cli
            ;;
        fedora)
            local sudo="${SUDO:-}"
            $sudo dnf install -y "${common_pkgs[@]}" findutils g++ ninja-build libstdc++-static
            ;;
        debian|ubuntu)
            local sudo="${SUDO:-}"
            $sudo apt update && $sudo apt install -y "${common_pkgs[@]}" findutils g++ ninja-build
            ;;
        *)
            echo "OS ($os) is not supported"
            exit 1
            ;;
    esac
}

function install_mise() {
    if command -v mise &>/dev/null; then
        echo_blue "** mise already installed"
        return
    fi
    echo_blue "** Installing mise"
    curl https://mise.run | sh
    eval "$(~/.local/bin/mise activate bash)"
}

function prepare_dotfiles_dir() {
    echo_blue "** Preparing dotfiles dir"

    if [ -d "$current_dir/.git" ] && git -C "$current_dir" remote -v 2>/dev/null | grep -q "ammarnajjar/dotfiles"; then
        dotfiles_dir="$current_dir"
        echo_blue "** Already inside dotfiles repo, skipping clone"
        return
    fi

    dotfiles_dir="$current_dir/dotfiles"
    backup "$dotfiles_dir"
    git clone --depth=1 "$DOTFILES_REPO" "$dotfiles_dir"
}

function setup_xdg() {
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
}

function setup_nvim() {
    echo_blue "** Neovim config"
    ln -sfn "$dotfiles_dir/nvim" "$XDG_CONFIG_HOME/nvim"
}

function setup_tmux() {
    echo_blue "** Tmux config"
    [ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf"
    ln -sfn "$dotfiles_dir/tmux" "$XDG_CONFIG_HOME/tmux"
}

function setup_git() {
    echo_blue "** Git config"
    backup "$XDG_CONFIG_HOME/git"
    wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
        -O "$dotfiles_dir/git/git-completion.bash" || echo_blue "Warning: failed to download git-completion.bash"
    ln -sfn "$dotfiles_dir/git" "$XDG_CONFIG_HOME/git"
}

function setup_bat() {
    echo_blue "** Bat config"
    mkdir -p "$XDG_CONFIG_HOME/bat"
    ln -sf "$dotfiles_dir/bat/config" "$XDG_CONFIG_HOME/bat/config"
}

function setup_mise_defaults() {
    echo_blue "** Mise default packages"
    ln -sf "$dotfiles_dir/mise/default-cargo-crates" "$HOME/.default-cargo-crates"
    ln -sf "$dotfiles_dir/mise/default-gems" "$HOME/.default-gems"
    ln -sf "$dotfiles_dir/mise/default-python-packages" "$HOME/.default-python-packages"
    ln -sf "$dotfiles_dir/mise/default-node-packages" "$HOME/.default-node-packages"
}

function setup_terminfo() {
    echo_blue "** Compiling terminfo"
    tic -o "$HOME/.terminfo" "$dotfiles_dir/shell/terminfo"
}

function setup_shell() {
    local user_shell
    user_shell="$(basename "$SHELL")"
    echo_blue "** Shell config (detected: $user_shell)"

    cd "$dotfiles_dir" || return

    case "$user_shell" in
        zsh)
            backup "$HOME/.zshrc"
            cat > "$HOME/.zshrc" <<EOF
export dotfiles_dir=$dotfiles_dir
source $dotfiles_dir/shell/zsh/zshrc
EOF
            [ -d "$dotfiles_dir/shell/zsh/powerlevel10k" ] || \
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dotfiles_dir/shell/zsh/powerlevel10k"
            [ -d "$dotfiles_dir/shell/zsh/zsh-syntax-highlighting" ] || \
                git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$dotfiles_dir/shell/zsh/zsh-syntax-highlighting"
            ln -sf "$dotfiles_dir/shell/zsh/p10k.zsh" "$HOME/.p10k.zsh"
            ;;
        bash)
            backup "$HOME/.bashrc"
            cat > "$HOME/.bashrc" <<EOF
export dotfiles_dir=$dotfiles_dir
source $dotfiles_dir/shell/bash/bashrc
EOF
            [ -d "$dotfiles_dir/shell/bash/bash-sensible" ] || \
                git clone --depth=1 -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git "$dotfiles_dir/shell/bash/bash-sensible"
            ;;
        *)
            echo_blue "Warning: unsupported shell ($user_shell), skipping shell setup"
            return
            ;;
    esac

    cd "$current_dir" || return
}

function main() {
    local uid
    uid="$(id -u)"
    if [[ $uid -ne 0 ]]; then
        SUDO="sudo"
    else
        SUDO=""
    fi

    install_pkgs
    install_mise
    prepare_dotfiles_dir

    setup_xdg
    setup_nvim
    setup_tmux
    setup_git
    setup_bat
    setup_mise_defaults
    setup_terminfo
    setup_shell

    echo_blue "** Installation Complete **"
    echo_blue "** Restart your shell or run: exec $SHELL"
}

current_dir=$(pwd)
main "$@"

# vim: set ft=sh ts=4 sw=4 et ai :
