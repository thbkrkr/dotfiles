## dotfiles

Tracked via a bare git repo (`~/.dotfiles`), work-tree is `$HOME`.

### Setup on a new machine

```sh
git clone --bare https://github.com/thbkrkr/dotfiles.git ~/.dotfiles
alias git='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git checkout main
git config --local status.showUntrackedFiles no
```

Setup untracked git identity (name/email):
```sh
echo '[user]
    name = Your Name
    email = your@email.com' > ~/.gitconfig.local
```

### Syncing changes

The `git` alias is active in `~` (set by the `chpwd` hook in `.zshrc`), pointing at the bare repo.

**Edit files directly in `$HOME` and push to GitHub:**
```sh
cd ~
git add .zshrc
git commit -m "update zsh config"
git push origin main
```
