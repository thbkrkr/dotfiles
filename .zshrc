ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pure-thb"

# Set to this to use case-sensitive completion
#CASE_SENSITIVE="true"
# Comment this out to disable weekly auto-update checks
#DISABLE_AUTO_UPDATE="true"
# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

plugins=(git heroku history-substring-search)
source $ZSH/oh-my-zsh.sh

export PATH=~/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Aliases

alias get='sudo apt-get install -y'
alias search='sudo apt-cache search'

alias h='history'
alias c='clear'
alias d='docker'
alias g='git'

# Git aliases
alias gs='git status'
alias gst='git status'
alias gpr='git pull --rebase'
alias grrh='git reset --hard HEAD'
alias gcdf='git clean -df'
alias gcam='git commit --amend'
git_rebase_interactif_f() {
    git rebase -i HEAD~$1
}
alias gri=git_rebase_interactif_f
alias gspp='git stash && git pull --rebase && git stash pop'

# Docker aliases
db() { docker build -t="$1" .; }
drm() { docker rm $(docker ps -q -a); }
dri() { docker rmi $(docker images -q); }
alias dkd="docker run -d -P"
alias dki="docker run -t -i -P"

# always $cmd $sleepDuration
always_f() {
	"while true; do "$1"; sleep $2; done"
}
alias always=always_f

# grepcode $path $fileExtension $grepRegexp
grepcode_f() {
	echo 'find '$1' -name "*.'$2'" | xargs grep -Hn '$3
	find $1 -name "*.$2" | xargs grep -Hn $3
}
alias grepcode=grepcode_f

# Source optional ~/.myzshrc
[ -f ~/.myzshrc ] && source ~/.myzshrc
