# Dotfiles Configurations

My dotfiles configurations for neovim, git, bash and tmux.  
It will be installed in the current directory with symlinks to the correct paths.  

## Usage:

Make a **backup** for your settings (or else look for them under /tmp/trash/..).  
Then:

```bash
wget https://raw.githubusercontent.com/ammarnajjar/dotfiles/master/install.sh && bash install.sh
```

## Files in repo:

```bash
.
├── README.md
├── bash
│   └── bashrc
├── coc-settings.json
├── git
│   ├── config
│   ├── git-completion.bash
│   └── gitmessage
├── init.vim
├── install.sh
├── tmux
│   └── tmux.conf
└── LICENSE
```

I have full explanation to my neovim configurations [here](https://ammarnajjar.github.io/editors/2016/06/19/Vimrc-Adventure/).  
