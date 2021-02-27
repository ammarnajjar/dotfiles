# Dotfiles Configurations

My dotfiles configurations.  
It will be installed in the current directory with symlinks to the relatedd system paths.

## Usage:

Make a **backup** for your settings (or else look for them under /tmp/trash/..).
Then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && $0 install.sh
```

<details><summary>Tools supported:</summary>

- [vim](https://github.com/vim/vim)

- [neovim](https://github.com/neovim/neovim)

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
│   └── init.vim
├── shell
│   ├── bash
│   │   └── bashrc
│   ├── common.sh
│   ├── terminfo
│   └── zsh
│       └── zshrc
├── tmux
│   └── tmux.conf
└── vim
    ├── README.md
    ├── coc-settings.json
    ├── link.sh
    └── vimrc
```
</details>

I have full explanation to my vimrc [here](https://ammarnajjar.github.io/editors/2016/06/19/Vimrc-Adventure/)
