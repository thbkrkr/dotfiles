ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pure-thb"

#CASE_SENSITIVE="true"
#DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git heroku history-substring-search)
source $ZSH/oh-my-zsh.sh

export PATH=~/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Aliases

alias h='history'
alias c='clear'
alias m='make'
alias d='docker'
alias g='git'

# Apt
alias get='sudo apt-get install -y'
alias search='sudo apt-cache search'

# Git aliases
alias gs='git status'
alias gst='git status'
alias gpr='git pull --rebase'
alias grrh='git reset --hard HEAD'
alias gcdf='git clean -df'
alias gcam='git commit --amend'
alias gspp='git stash && git pull --rebase && git stash pop'
gri() { git rebase -i HEAD~$1; }

# Docker aliases
db() { docker build -t="$1" .; }
drm() { docker rm $(docker ps -q -a); }
dri() { docker rmi $(docker images -q --filter "dangling=true"); }
dgo() { docker exec -ti $@ bash }
dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"; }
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
