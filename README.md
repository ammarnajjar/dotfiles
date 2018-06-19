# Dotfiles Configurations

My own neovim configurations for fedora/debian, git, and tmux.
It will be installed in the current directory with symlinks to the correct paths.  
Because the plugins are always changing and depend on the current projects I am working on, I put them in another file `plugs.vim` and source them to `init.vim`. They are also treated on another branch locally.

## Install using: 

Make a backup for your settings then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```

## Files in repo:

```bash
.
├── bash
│   └── bashrc
├── git
│   ├── git-completion.bash
│   └── gitconfig
├── .gitignore
├── install.sh
├── LICENSE
├── plugs.vim
├── README.md
├── tmux
│   └── tmux.conf
├── init.vim
└── .ycm_extra_conf.py

3 directories, 11 files
```

I have full explanation to my configurations [here](https://ammarnajjar.github.io/editors/2016/06/19/Vimrc-Adventure/).  

## License:

GNU GENERAL PUBLIC LICENSE, see LICENSE file for details.
