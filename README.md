# Dotfiles Configurations

My own vim/neovim configurations for fedora/debian, Tmux and urxvt.  
It will be installed in the current directory with symlinks to the correct paths.  
Because the plugins are always changing and depend on the current projects I am working on, I put them in another file `plugs.vim` and source them to my `vimrc.vim`. They are also treated on another branch locally.

## Install using: 

Make a backup for your settings then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```
This script gives the possibility to build vim from source as well using the `-b` option, or neovim using the `-n` option:

```bash
Usage:
    bash install.sh [option]
    Options:
        -h --help                 : Show this help messaage.
        -b --build-from-source    : Build vim from source.
        -n --neovim               : Build neovim from source.
```

## Files in repo:

```bash
.
├── bashrc
├── install.sh
├── LICENSE
├── plugs.vim
├── README.md
├── tmux.conf
├── urxvt
│   ├── fullscreen
│   ├── resize-font
│   └── Xresources
└── vimrc.vim

1 directory, 10 files
```

##License:

GNU GENERAL PUBLIC LICENSE, see LICENSE file for details.
