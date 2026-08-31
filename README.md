
# Dotfiles

Personal dev environment for macOS and Linux (Fedora, Debian, Ubuntu).

## Quick Start

**Fresh machine (nothing installed):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ammarnajjar/dotfiles/main/install.sh)
```

**Already cloned:**

```bash
cd dotfiles && bash install.sh
```

The script is idempotent and safe to re-run.

## What Gets Installed

`install.sh` handles everything:

- **Xcode CLT** (macOS) and **Homebrew** if missing
- **System packages**: git, curl, tmux, fzf, gnupg, tree, wget, ninja, tree-sitter-cli, atuin, kubectl
- **Mise** runtime manager with: Python, Node.js (LTS), Rust, Ruby
- **Neovim** 0.12+ (via brew on macOS, via mise on Linux)
- **Cargo crates**: bat, ripgrep, git-delta, fd-find
- **Config symlinks**: nvim, tmux, git, bat to `~/.config/`
- **Shell setup**: zsh (powerlevel10k, zsh-syntax-highlighting) or bash (bash-sensible)

### Post-install (manual)

1. Import GPG key: `gpg --import <key-file>`
2. Open nvim to trigger treesitter parser installs
3. Restart shell: `exec $SHELL`

## Structure

```
nvim/               Neovim config (Lua, lazy.nvim, Neovim 0.12+)
shell/
  common.sh         Shared aliases, functions, env (bash + zsh)
  zsh/              zshrc, powerlevel10k, zsh-syntax-highlighting
  bash/             bashrc, bash-sensible
tmux/tmux.conf      Tmux config (vi keys, 256color)
git/
  config            Aliases, delta pager, GPG signing
  gitignore         Global ignores
  gitmessage        Commit template
bat/config          Bat theme (Sublime Snazzy)
mise/               Default packages for cargo, node, python, ruby
vim/vimrc.vim       Legacy Vim config
install.sh          Bootstrap script
```

## Contributing / Feedback

Feel free to open an issue or PR if you find a bug or have suggestions for improvements.

## License

MIT
