# Dotfiles Configurations

My dotfiles configurations.  
It will be installed in the current directory with symlinks to the correct paths.  

## Usage:

Make a **backup** for your settings (or else look for them under /tmp/trash/..).  
Then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```

## Tools supported:

- [vim](https://github.com/vim/vim)
- [neovim](https://github.com/neovim/neovim)
- [bash](https://www.gnu.org/software/bash/)
- [zsh](https://www.zsh.org/)
- [git](https://git-scm.com/)
- [tmux](https://github.com/tmux/tmux)
- [asdf](https://github.com/asdf-vm/asdf)

## Files in repo:

```bash
.
├── LICENSE
├── README.md
├── addons.vim
├── asdf
│   ├── default-node-packages
│   └── default-python-packages
├── bash
│   └── bashrc
├── coc-settings.json
├── git
│   ├── config
│   └── gitmessage
├── init.vim
├── install.sh
├── tmux
│   └── tmux.conf
└── zsh
    └── zshrc
```

I have full explanation to my configurations [here](https://ammarnajjar.github.io/editors/2016/06/19/Vimrc-Adventure/)
