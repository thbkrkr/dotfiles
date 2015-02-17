#
# ZSH configuration propulsed by https://github.com/robbyrussell/oh-my-zsh
# and https://github.com/thbkrkr/dotfiles
#

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pure-thb"

#CASE_SENSITIVE="true"
#DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(git docker git history-substring-search)
source $ZSH/oh-my-zsh.sh

export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

##########################

# Tiny aliases
alias c='clear'
alias d='docker'
alias g='git'
alias h='history'
alias m='make'
alias s='ssh'
alias wholisten='netstat -antulp | grep LISTE'

# Apt aliases
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

# Functions aliases

# always $cmd $sleepDuration
always() { while true; do "$($1)"; sleep $2; done; }

# grepcode $path $fileExtension $grepRegexp
grepcode() { find $1 -name "*.$2" | xargs grep -Hn $3; }

# curl with response code and total time
cuurl() { curl $@ -w "\n@status=%{response_code}\n@time=%{time_total}\n"; }

# curl and format response with JQ
jc() { curl -s "$1" | jq .; }

geoip() { curl -s www.telize.com/geoip | jq .; }

##########################

# Source optional ~/.myzshrc
[ -f ~/.myzshrc ] && source ~/.myzshrc
