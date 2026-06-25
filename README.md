# dotfiles

Tracked via a bare git repo (`~/.dotfiles`), work-tree is `$HOME`.

## Setup on a new machine

```bash
git clone --bare https://github.com/thbkrkr/dotfiles.git ~/.dotfiles
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config checkout home
config config --local status.showUntrackedFiles no
```

Identity (name/email) goes in the untracked `~/.gitconfig.local`:

```ini
[user]
    name = Your Name
    email = your@email.com
```

## Tracked files

- `~/.myzshrc` — shell config (sourced by `~/.zshrc`)
- `~/.gitconfig` — git config (identity via `~/.gitconfig.local`)
- `~/.gitignore_global`
- `~/.tmux.conf`
- `~/.config/ghostty/config`
- `~/.config/starship.toml`
