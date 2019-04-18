# Dotfiles Configurations

My dotfiles configurations for neovim, git, bash and tmux.  
It will be installed in the current directory with symlinks to the correct paths.  
Because the plugins are always changing and depend on the current projects I am working on, I put them in another file `plugs.vim` and source them to `init.vim`. They are also treated on another branch locally.

## Usage:

Make a **backup** for your settings then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```

## Files in repo:

```bash
.
├── install.sh
├── bash
│   └── bashrc
├── git
│   ├── config
│   ├── git-completion.bash
│   └── gitmessage
├── init.vim
├── plugs.vim
├── tmux
│   └── tmux.conf
├── README.md
└── LICENSE
```

I have full explanation to my neovim configurations [here](https://ammarnajjar.github.io/editors/2016/06/19/Vimrc-Adventure/).  

## License:

GNU GENERAL PUBLIC LICENSE, see LICENSE file for details.
