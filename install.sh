#!/usr/bin/env bash
set -euo pipefail

# Bootstrap: curl -fsSL https://raw.githubusercontent.com/ammarnajjar/dotfiles/main/install.sh | bash

readonly DOTFILES_REPO="https://github.com/ammarnajjar/dotfiles.git"
STEPS_DONE=()
SKIPPED=()
OS=""

function echo_blue() {
    echo -e '\E[37;44m'"\033[1m$1\033[0m"
}

function echo_warn() {
    echo -e '\033[0;33m'"⚠ $1"'\033[0m'
}

function step_done() {
    STEPS_DONE+=("$1")
}

function step_skip() {
    SKIPPED+=("$1")
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

function is_linux() {
    [[ "$OS" != "macos" ]]
}

# --- Package installation ---

function install_homebrew() {
    if command -v brew &>/dev/null; then
        return
    fi
    echo_blue "** Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
}

function install_pkgs() {
    OS=$(detect_os)
    echo_blue "** Installing packages (OS: $OS)"

    case "$OS" in
        macos)
            install_homebrew
            brew install git curl tmux neovim fzf gnupg tree \
                ninja tree-sitter-cli wget atuin kubectl 2>/dev/null || true
            ;;
        fedora)
            $SUDO dnf install -y git curl tmux neovim fzf gnupg2 tree \
                findutils g++ ninja-build libstdc++-static wget xclip
            command -v atuin &>/dev/null || {
                curl -fsSL https://setup.atuin.sh | bash
            } || step_skip "atuin (install failed)"
            ;;
        debian|ubuntu)
            $SUDO apt update
            $SUDO apt install -y git curl tmux neovim fzf gnupg tree \
                findutils g++ ninja-build wget xclip
            command -v atuin &>/dev/null || {
                curl -fsSL https://setup.atuin.sh | bash
            } || step_skip "atuin (install failed)"
            ;;
        *)
            echo "OS ($OS) is not supported"
            exit 1
            ;;
    esac
    step_done "packages ($OS)"
}

# --- Mise ---

function install_mise() {
    if ! command -v mise &>/dev/null; then
        echo_blue "** Installing mise"
        curl -fsSL https://mise.run | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
    eval "$(mise activate bash)"
    step_done "mise"
}

function setup_mise_defaults() {
    echo_blue "** Mise default packages"
    ln -sf "$dotfiles_dir/mise/default-cargo-crates" "$HOME/.default-cargo-crates"
    ln -sf "$dotfiles_dir/mise/default-gems" "$HOME/.default-gems"
    ln -sf "$dotfiles_dir/mise/default-python-packages" "$HOME/.default-python-packages"
    ln -sf "$dotfiles_dir/mise/default-node-packages" "$HOME/.default-node-packages"
    step_done "mise defaults"
}

function install_mise_runtimes() {
    echo_blue "** Installing mise runtimes"

    local runtimes=(python@latest node@lts rust@latest ruby@latest)
    for rt in "${runtimes[@]}"; do
        echo_blue "   $rt"
        mise use --global "$rt" || {
            echo_warn "Failed to install $rt, continuing"
            step_skip "$rt"
        }
    done

    eval "$(mise activate bash)"
    step_done "runtimes"
}

# --- Dotfiles repo ---

function prepare_dotfiles_dir() {
    echo_blue "** Preparing dotfiles dir"

    if [ -d "$current_dir/.git" ] && git -C "$current_dir" remote -v 2>/dev/null | grep -q "ammarnajjar/dotfiles"; then
        dotfiles_dir="$current_dir"
        echo_blue "** Already inside dotfiles repo, skipping clone"
    else
        dotfiles_dir="$current_dir/dotfiles"
        backup "$dotfiles_dir"
        git clone --depth=1 "$DOTFILES_REPO" "$dotfiles_dir"
    fi
    step_done "dotfiles"
}

# --- Config symlinks ---

function setup_xdg() {
    mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
}

function setup_nvim() {
    echo_blue "** Neovim config"
    ln -sfn "$dotfiles_dir/nvim" "$XDG_CONFIG_HOME/nvim"
    step_done "nvim"
}

function setup_tmux() {
    echo_blue "** Tmux config"
    [ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf"
    ln -sfn "$dotfiles_dir/tmux" "$XDG_CONFIG_HOME/tmux"
    step_done "tmux"
}

function setup_git() {
    echo_blue "** Git config"
    backup "$XDG_CONFIG_HOME/git"
    curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
        -o "$dotfiles_dir/git/git-completion.bash" || echo_warn "Failed to download git-completion.bash"
    ln -sfn "$dotfiles_dir/git" "$XDG_CONFIG_HOME/git"
    step_done "git"
}

function setup_bat() {
    echo_blue "** Bat config"
    mkdir -p "$XDG_CONFIG_HOME/bat"
    ln -sf "$dotfiles_dir/bat/config" "$XDG_CONFIG_HOME/bat/config"
    step_done "bat"
}

function setup_terminfo() {
    echo_blue "** Compiling terminfo"
    tic -o "$HOME/.terminfo" "$dotfiles_dir/shell/terminfo"
    step_done "terminfo"
}

function setup_fzf() {
    if command -v fzf &>/dev/null; then
        local user_shell
        user_shell="$(basename "$SHELL")"
        case "$user_shell" in
            bash)
                # generate fzf bash integration if missing
                [ -f "$HOME/.fzf.bash" ] || fzf --bash > "$HOME/.fzf.bash" 2>/dev/null || true
                ;;
        esac
        step_done "fzf"
    else
        step_skip "fzf (not found)"
    fi
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
            echo_warn "Unsupported shell ($user_shell), skipping shell setup"
            cd "$current_dir" || return
            step_skip "shell ($user_shell)"
            return
            ;;
    esac

    cd "$current_dir" || return
    step_done "shell ($user_shell)"
}

# --- Summary ---

function print_summary() {
    echo ""
    echo_blue "=============================="
    echo_blue "  Installation Complete"
    echo_blue "=============================="
    echo ""
    for step in "${STEPS_DONE[@]}"; do
        echo -e "  \033[0;32m✓\033[0m $step"
    done
    if [[ ${#SKIPPED[@]} -gt 0 ]]; then
        echo ""
        for step in "${SKIPPED[@]}"; do
            echo -e "  \033[0;33m⚠\033[0m $step"
        done
    fi
    echo ""
    echo_blue "Post-install (manual):"
    echo "  1. Import GPG key:  gpg --import <key-file>"
    echo "  2. Install parsers: nvim (opens, parsers auto-install)"
    echo "  3. Restart shell:   exec $SHELL"
    echo ""
    echo "Re-run this script anytime to update. It is safe to run repeatedly."
    echo ""
}

# --- Main ---

function main() {
    if [[ "$(id -u)" -ne 0 ]]; then
        SUDO="sudo"
    else
        SUDO=""
    fi

    install_pkgs
    install_mise
    prepare_dotfiles_dir

    setup_xdg
    setup_mise_defaults
    install_mise_runtimes
    setup_nvim
    setup_tmux
    setup_git
    setup_bat
    setup_fzf
    setup_terminfo
    setup_shell

    print_summary
}

current_dir=$(pwd)
main "$@"

# vim: set ft=sh ts=4 sw=4 et ai :
