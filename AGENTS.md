# Dotfiles

Personal dev environment configs. macOS + Linux (Fedora/Debian/Ubuntu).
Install: `bash install.sh` clones repo, symlinks everything to `~/.config/`.

## Structure
```
nvim/               Neovim config (Lua, lazy.nvim)
  init.lua          Entry: leader=, loads config/* then lazy
  lua/config/       options, keymaps, autocmds, lazy (plugin manager bootstrap)
  lua/plugins/      cmp, lsp, lualine, neo-tree, telescope, treesitter
shell/
  common.sh         Shared env, aliases, functions (sourced by both bash/zsh)
  zsh/              zshrc, p10k.zsh, powerlevel10k/, zsh-syntax-highlighting/
  bash/             bashrc
  terminfo/         Custom terminfo entries
tmux/tmux.conf      tmux config (vi keys, 256color, history 1M)
git/
  config            Aliases, delta pager, GPG signing, commit template
  gitignore         Global ignores
  gitmessage        Commit template
  git-completion.bash
vim/vimrc.vim       Legacy Vim config (rarely changed)
bat/config          bat theme (Sublime Snazzy)
mise/               Default packages: cargo-crates, node-packages, python-packages, gems
```

## Languages
- Lua: nvim config (indent: 2 spaces)
- Shell/Bash/Zsh: shell configs, install.sh (indent: 4 spaces)
- VimScript: legacy vim/vimrc.vim

## Key Conventions
- XDG paths: configs symlinked to `$XDG_CONFIG_HOME` (`~/.config/`)
- Mise default files symlinked to `$HOME` (`.default-cargo-crates`, etc.)
- Editor: nvim everywhere (EDITOR, GIT_EDITOR, git core.editor)
- Theme: Sublime Snazzy (delta, bat)
- Git pager chain: `delta || less || nvim`
- Shell modelines: `# vim: set ft=sh ts=4 sw=4 et ai :` at end of shell files
- Lua modelines: `-- vim: ft=lua ts=2 sw=2 et ai` at end of Lua files

## Verification
No test suite, no CI, no linter. After changes:
- Shell: `bash -n <file>` or `zsh -n <file>` for syntax check
- Lua: check `.luarc.json` globals (`vim`, `use` are valid)
- Full validation: run `install.sh` on a clean environment (destructive, moves existing configs to `/tmp/trash/`)

## Tool Selection
```
file search    → fd            text search    → rg
Lua structure  → treesitter    shell check    → bash -n / zsh -n
```

## Project Rules

### Neovim Config
- Plugin manager: lazy.nvim (bootstrapped in `lua/config/lazy.lua`)
- New plugins go in `lua/plugins/` as separate files (lazy.nvim auto-discovers)
- Leader key: `,` (set in init.lua before any plugin loads)
- LSP servers configured in `lua/plugins/lsp.lua`

### Shell Config
- `shell/common.sh` is shared between bash and zsh; keep it POSIX-compatible where possible
- Bash-only code in `shell/bash/bashrc`, zsh-only in `shell/zsh/zshrc`
- fzf config lives in common.sh with fd as default command

### Git Config
- GPG signing enabled (key `4E358D38135EE7EA`)
- Delta configured with line numbers and decorations
- `push.default = current`, `pull.rebase = false`, `init.defaultBranch = main`
- Do not modify `git/git-completion.bash` (downloaded from upstream)

### install.sh
- Idempotent intent: moves existing configs to `/tmp/trash/` with timestamp before symlinking
- Supports: Fedora (dnf), Debian/Ubuntu (apt), macOS (brew)
- Functions run in order: install_pkgs, prepare_dotfiles_dir, mise_setup, nvim_symlinks, compile_terminfo, update_tmux_conf, update_git_conf, prepare_shell_rc_file

### Style
- No trailing whitespace
- Files end with newline
- Preserve existing modelines
