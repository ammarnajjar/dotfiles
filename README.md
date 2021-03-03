# Dotfiles Configurations

It will be installed in the current directory (where [`install.sh`](install.sh) is run) with symlinks to the related system paths.

## Usage:

Make a **backup** for your settings, only then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && $0 install.sh
```

<details><summary>Tools supported:</summary>

- [vim](https://github.com/vim/vim): these configurations support also neovim version < 0.5.0, one need to link them manually though.

- [neovim](https://github.com/neovim/neovim): by default version >= 0.5.0 is supported see [`init.lua`](nvim/init.lua).

- [bash](https://www.gnu.org/software/bash/)

- [zsh](https://www.zsh.org/)

- [git](https://git-scm.com/)

- [tmux](https://github.com/tmux/tmux)

- [asdf](https://github.com/asdf-vm/asdf)

- [direnv](https://github.com/direnv/direnv)

</details>

<details><summary>Files in repository:</summary>

```bash
.
├── LICENSE
├── README.md
├── asdf
│   ├── default-cargo-crates
│   ├── default-gems
│   ├── default-node-packages
│   └── default-python-packages
├── bat
│   └── config
├── direnv
│   ├── direnvrc
│   └── envrc
├── git
│   ├── config
│   └── gitmessage
├── install.sh
├── nvim
│   └── init.lua
├── shell
│   ├── bash
│   │   └── bashrc
│   ├── common.sh
│   └── zsh
│       └── zshrc
├── tmux
│   └── tmux.conf
└── vim
    ├── README.md
    ├── coc-settings.json
    ├── link.sh
    └── vimrc.vim
```
</details>

*This is my personal configurations, use at your own risk.*

