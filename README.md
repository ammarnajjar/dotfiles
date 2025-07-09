
# 🛠️ Ammar Najjar’s Dotfiles

This repository contains my personal configuration files (dotfiles) for setting up a consistent and productive development environment across macOS and Linux systems (Fedora, Debian, Ubuntu).

---

## 📦 Contents

This setup includes configurations for:

- **Shells**: Bash, Zsh
- **Editors**: Vim, Neovim
- **Terminal Multiplexer**: Tmux
- **Version Control**: Git
- **Syntax Highlighting**: Bat
- **Version Management**: Mise (Node.js, Python, Ruby, Rust)

---

## 🚀 Installation

**⚠️ Warning:** Backup your current configuration files before proceeding.

To install and set up these dotfiles:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```

This script will:
- Clone the repository locally
- Create symbolic links from the dotfiles to the appropriate locations in your system
- Set up editors and tools accordingly

---

## 🧰 Configuration Details

### 🐚 Shell Configs

- **Bash**:  
  `shell/bash/bashrc` – Shell prompt, aliases, history settings.

- **Zsh**:  
  `shell/zsh/zshrc` – Custom themes, completions, aliases.

- **Shared Configs**:  
  `shell/common.sh` – Environment variables and common utilities used across Bash and Zsh.

---

### 📝 Editor Configs

- **Neovim (v0.5.0+)**:  
  `nvim/init.lua` – Plugin setup, keymaps, and Lua-based configuration.

- **Vim / Legacy Neovim**:  
  `vim/vimrc.vim` – Compatible with older Vim/Neovim versions.  
  `vim/link.sh` – Helper script to symlink `.vimrc`.

---

### 🔄 Tmux Config

- `tmux/tmux.conf` – Key remappings, status bar tweaks, theme, and plugins.

---

### 🧬 Git Config

- `git/config` – Global Git settings (color, aliases, defaults).
- `git/gitmessage` – Standard commit message template.

---

### 🌈 Bat Config

- `bat/config` – Settings for the syntax-highlighted pager (`bat`).

---

### 📦 Mise Default Packages

Managed language versions and default packages:

- `mise/default-node-packages` – e.g., eslint, typescript
- `mise/default-python-packages` – e.g., ipython, black
- `mise/default-gems` – Ruby default gems
- `mise/default-cargo-crates` – Rust tools like ripgrep, fd

---

## 🛠️ Advanced Management (Optional)

For more structured and automated management, refer to the companion repository:  
👉 [ammarnajjar/manage-dotfiles](https://github.com/ammarnajjar/manage-dotfiles)

---

## 🪪 License

MIT License © [Ammar Najjar](https://github.com/ammarnajjar)

---

## 🙋‍♂️ Contributing / Feedback

Feel free to open an issue or PR if you find a bug or have suggestions for improvements. This setup is tailored to my workflow, but I welcome feedback or ideas for making it more flexible.
