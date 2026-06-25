## dotfiles

Tracked via a bare git repo (`~/.dotfiles`), work-tree is `$HOME`.

### Setup on a new machine

```sh
git clone --bare https://github.com/thbkrkr/dotfiles.git ~/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout home
dotfiles config --local status.showUntrackedFiles no
```

Setup untracked git identity (name/email):
```sh
echo '[user]
    name = Your Name
    email = your@email.com' > ~/.gitconfig.local
```
