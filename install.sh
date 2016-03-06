#!/usr/bin/bash

rm -rf $HOME/.vim $HOME/.vimrc
rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config

id="$(cat /etc/*release | grep ID=)"
if [[ "$id" == *"fedora"* ]]
then
	# fedora based install dependencies
	sudo dnf update -y
	sudo dnf -y install vim vim-X11 git libtool autoconf automake cmake gcc gcc-c++ \
		make pkgconfig unzip python-pip redhat-rpm-config clang \
		powerline kernel-devel python-devel
	sudo pip install neovim
	echo "source '/usr/share/tmux/powerline.conf'" > $HOME/.tmux.conf
elif [[ "$id" == *"debian"* ]]
then
	# Debian based install
	sudo apt-get update && sudo apt-get install -y \
	vim vim-gtk git silversearcher-ag exuberant-ctags clang	powerline \
	build-essential libtool
	sudo pip install neovim
	echo "source '/usr/share/powerline/bindings/tmux/powerline.conf'" > $HOME/.tmux.conf
elif [[ "$id" == *"ubuntu"* ]]
then
	# Ubuntu based install
	sudo apt-get update && sudo apt-get install -y \
	vim vim-gtk git silversearcher-ag exuberant-ctags clang build-essential \
	automake python-dev python-pip python3-dev python3-pip libtool
	sudo pip install neovim
fi

current_dir=$(pwd)
vim_dir="$current_dir/dotfiles"
bin_dir="$vim_dir/neovim_bin"
source_dir="$vim_dir/neovim_source"
if [ -d $vim_dir ]
then
	rm -rf $vim_dir
fi
mkdir -p $vim_dir

cd $vim_dir
git clone https://github.com/ammarnajjar/dotfiles.git .
git clone https://github.com/neovim/neovim.git $source_dir

cd $source_dir
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$bin_dir"
make install

cd $vim_dir
# # install powerline fonts
# git clone https://github.com/powerline/fonts fonts
# sh fonts/install.sh

# install bash-sensible (myfork)
# git clone https://github.com/mrzool/bash-sensible.git
git clone -b 'ignored-in-history' https://github.com/ammarnajjar/bash-sensible.git
if [ -f $HOME/.bashrc ]
then
	echo 'source ~/.vim/bash-sensible/sensible.bash' >> ~/.bashrc
fi

# install liquid prompt
# git clone https://github.com/nojhan/liquidprompt.git liquidprompt
git clone -b twolinedprompt https://github.com/ammarnajjar/liquidprompt.git liquidprompt
if [ -f $HOME/.bashrc ]
then
	echo '[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquidprompt' >> ~/.bashrc
	echo '[[ $- = *i* ]] && source ~/.vim/liquidprompt/liquid.theme' >> ~/.bashrc
	source ~/.bashrc
fi

if [ -f $HOME/.tmux.conf ]
then
	echo "set -g history-limit 1000000" >> $HOME/.tmux.conf
else
	echo "set -g history-limit 1000000" > $HOME/.tmux.conf
fi
echo "set -s escape-time 0" >> $HOME/.tmux.conf
rm $HOME/.Xresources

# create symlinks
ln -s $vim_dir $HOME/.vim
ln -s $vim_dir $HOME/.config/nvim
ln -s $vim_dir/init.vim $HOME/.vimrc
ln -s $vim_dir/Xresources $HOME/.Xresources
sudo ln -s "$bin_dir/bin/nvim" /usr/local/bin/nvim
git config --global alias.lol 'log --graph --decorate --pretty=oneline --abbrev-commit --all'

# Install plugins
mkdir -p $vim_dir/plugged $vim_dir/undo
curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall

echo "Installation Complete"
# vim: set ft=sh ts=4 sw=4 noet ai :
