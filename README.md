# Dotfiles Configurations

My own vim configurations for fedora/debian, Tmux and urxvt.  
It will be installed in the current directory with symlinks to the correct paths.  
Because the plugins are always changing and depend on the current projects I am working on, I put them in `plugins` branch.

## Install using: 

Make a backup for your settings then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```
This script gives the possibility to build vim from source as well using the "-b" option:

```bash
Usage:
    bash install.sh [option]
    Options:
        -b --build-from-source: Build vim from source.
        -h --help             : Show this help messaage.
```

## Files in repo:

	.
	├── .gitignore
	├── vimrc.vim
	├── bashrc
	├── install.sh
	├── LICENSE
	├── README.md
	└── Xresources

	0 directories, 7 files

##License:

GNU GENERAL PUBLIC LICENSE, see LICENSE file for details.
