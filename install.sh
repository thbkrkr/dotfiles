#!/bin/sh

# @deps : apt-get, git

# Install zsh
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.save.$(date +%s)
if [ $(which zsh > /dev/null; echo $?) -eq 1 ]
then
    touch ~/.zshrc 
    sudo apt-get install -y zsh
fi
sudo chsh -s `which zsh` `whoami`

# Clone oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]
then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
else
    cd ~/.oh-my-zsh
    git pull --rebase
fi

cp -f ~/.dotfiles/resources/pure-thb.zsh-theme ~/.oh-my-zsh/themes/

# Backup git user info
gitUserName=$(git config --global user.name)
gitUserEmail=$(git config --global user.email)

# Copy all dotfiles
cp ~/.dotfiles/dotfiles/.[a-z]* ~/

# Restore git user info
git config --global user.name $gitUserName
git config --global user.email $gitUserEmail

[ "x$gitUserName" = "x" ] && echo "Please update your git user.name, user.email : vi ~/.gitconfig"

zsh
