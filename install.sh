#!/bin/bash -eu
#
# Install and configure Zsh, oh-my-zsh and dotfiles.
#
# @deps : apt-get, sudo, git

echo "Install .dotfiles..."

# Install Zsh
if [ $(which zsh &> /dev/null; echo $?) -eq 1 ]
then
  touch $HOME/.zshrc 
  sudo apt-get install -y zsh
  sudo chsh -s `which zsh` `whoami`
fi

# Clone or update oh-my-zsh
ohMyZshDir=$HOME/.oh-my-zsh
if [ ! -d $ohMyZshDir ]; then
  git clone -q https://github.com/robbyrussell/oh-my-zsh.git $ohMyZshDir
else
  git --git-dir=$ohMyZshDir/.git --work-tree=$ohMyZshDir pull -q --rebase
fi

# Copy custom theme
cp -f $HOME/.dotfiles/resources/pure-thb.zsh-theme $ohMyZshDir/themes/

# Configure VIM

# Clone or update Vundle.vim
mkdir -p $HOME/.vim/bundle
vundleDir=$HOME/.vim/bundle/Vundle.vim
if [ ! -d $vundleDir ]; then
  git clone -q https://github.com/gmarik/Vundle.vim.git $vundleDir
else
  git --git-dir=$vundleDir/.git --work-tree=$vundleDir pull -q --rebase
fi
# Install monokai colors
mkdir -p $HOME/.vim/colors
curl -s https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim \
  > $HOME/.vim/colors/monokai.vim

# Backup git user info
set +e
gitUserName=$(git config --global user.name)
gitUserEmail=$(git config --global user.email)
set -e

# Copy all dotfiles
cp -f $HOME/.dotfiles/dotfiles/.[a-z]* $HOME/

# Copy all utils scripts
mkdir -p $HOME/bin && cp -f $HOME/.dotfiles/bin/* $HOME/bin

# Restore git user info
set +e
git config --global user.name $gitUserName
git config --global user.email $gitUserEmail
set -e

[ "x$gitUserName" = "x" ] && \
  echo "Please update your git user.name, user.email : vi $HOME/.gitconfig"

zsh
