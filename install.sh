#!/usr/bin/bash

rm -rf $HOME/.vim $HOME/.vimrc
rm $HOME/.Xresources
mkdir -p $HOME/.config

id="$(cat /etc/*release | grep ID=)"
if [[ "$id" == *"fedora"* ]]
then
	# fedora based install dependencies
	sudo dnf update -y
	sudo dnf -y install vim vim-X11 git libtool autoconf automake cmake gcc gcc-c++ \
		make pkgconfig unzip python-pip redhat-rpm-config clang \
		powerline kernel-devel python-devel the_silver_searcher ctags
	echo "source '/usr/share/tmux/powerline.conf'" > $HOME/.tmux.conf
elif [[ "$id" == *"debian"* ]]
then
	# Debian based install dependencies
	sudo apt-get update && sudo apt-get install -y \
	vim vim-gtk git silversearcher-ag exuberant-ctags clang	powerline \
	build-essential libtool
	echo "source '/usr/share/powerline/bindings/tmux/powerline.conf'" > $HOME/.tmux.conf
elif [[ "$id" == *"ubuntu"* ]]
then
	# Ubuntu based install dependencies
	sudo apt-get update && sudo apt-get install -y \
	vim vim-gtk git silversearcher-ag exuberant-ctags clang build-essential \
	automake python-dev python-pip python3-dev python3-pip libtool
fi

current_dir=$(pwd)
vim_dir="$current_dir/dotfiles"
if [ -d $vim_dir ]
then
	rm -rf $vim_dir
fi
mkdir -p $vim_dir
cd $vim_dir

git clone https://github.com/ammarnajjar/dotfiles.git .

# install bash-sensible && liquid prompt (myforks)
git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git
git clone -b twolinedprompt https://github.com/ammarnajjar/liquidprompt.git liquidprompt

echo 'function mkcd() { mkdir $1; cd $1; }'
echo 'alias ctagsit="ctags --append=no --recurse --totals --exclude=blib --exclude=.svn --exclude=.get --exclude='@.gitignore' --extra=q"' >> ~/.bashrc
echo 'alias g="git status"' >> ~/.bashrc
echo 'source ~/.vim/bash-sensible/sensible.bash' >> ~/.bashrc
echo '[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquidprompt' >> ~/.bashrc
echo '[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquid.theme' >> ~/.bashrc
source ~/.bashrc

echo "set -g history-limit 1000000" >> $HOME/.tmux.conf
echo "set -s escape-time 0" >> $HOME/.tmux.conf

# create symlinks
ln -s $vim_dir $HOME/.vim
ln -s $vim_dir/vimrc.vim $HOME/.vimrc
ln -s $vim_dir/Xresources $HOME/.Xresources

# git global aliases
git config --global alias.lol 'log --graph --decorate --pretty=oneline --abbrev-commit --all'
git config --global alias.st 'status'

# Install vundle & my colorscheme
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
git clone https://github.com/ammarnajjar/wombat256mod.git $HOME/.vim/bundle/wombat256mod
vim +PluginInstall +qall

echo "Installation Complete"
# vim: set ft=sh ts=4 sw=4 noet ai :
