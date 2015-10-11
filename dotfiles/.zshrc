#
# ZSH configuration propulsed by https://github.com/robbyrussell/oh-my-zsh
# and https://github.com/thbkrkr/dotfiles
#

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="pure-thb"

#CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git docker docker-compose git history-substring-search go)
source $ZSH/oh-my-zsh.sh

export HISTSIZE=100000
export PATH=~/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

##########################

# Tiny aliases
alias a='ansible'
alias c='clear'
alias d='docker'
alias dc='docker-compose'
alias dm='docker-machine'
alias g='git'
alias h='history'
alias m='make'
alias s='ssh'
alias sb=sensible-browser

# Git aliases
alias gst='git status'
alias gpr='git pull --rebase'
alias grrh='git reset --hard HEAD'
alias gcdf='git clean -df'
alias gcam='git commit --amend'
alias gcamne='git commit --amend --no-edit'
alias gspp='git stash && git pull --rebase && git stash pop'
alias glg='git lg --stat -C -4'
gri() { git rebase -i HEAD~$1; }

# Docker aliases
alias dkd="docker run -d -P"
alias dki="docker run --rm -P -ti"
alias dclean='~/bin/docker-cleanup.sh'
alias dcleanvol='~/bin/docker-cleanup-volumes.sh'
db()   { docker build --rm -t="$1" .; }
drm()  { docker rm $(docker ps -qa); }
drme() { docker rm $(docker ps -qa --filter 'status=exited'); }
dri()  { docker rmi $(docker images -q --filter "dangling=true"); }
dka()  { docker rm -f $(docker ps -aq) }
dgo()  { docker exec -ti $@ sh }
dgob() { docker exec -ti $@ bash }
dip()  { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"; }
dpid() { docker inspect --format '{{ .State.Pid }}' "$@"; }
dim()  { docker images | grep $@; }
dstats() { docker stats $(docker ps | grep -v CON | sed "s/.*\s\([a-z].*\)/\1/" | awk '{printf $1" "}'); }
dpush() {
  declare name=$1
  declare repo=$2
  docker tag -f $name $repo/$name
  docker push $repo/$name
}

# Apt
alias get='sudo apt-get install'
alias gety='sudo apt-get install -y'
alias search='sudo apt-cache search'

####
# Other aliases

# Tmux with terminal supports 256 colours
alias tmux='tmux -2'

# Display listened ports
alias wholisten='sudo netstat -antulp | grep LISTE'

####
# Helpful functions

# @help randpwd $length
randpwd() {
  local length=${1:-42}
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $length | head -1
}

# @help always $cmd $sleepDuration
always() { while true; do "$1"; sleep $2; done; }

# @help grepcode $path $fileExtension $grepRegexp
grepcode() { find $1 -name "*.$2" | xargs grep -Hn $3; }

# cURL functions
cuurl() { curl $@ -w "\n@status=%{response_code}\n@time=%{time_total}\n"; }
jc()    { curl -s "$1" | jq .; }
cl()    { curl -s localhost:$@; }
jcl()   { curl -s localhost:$@ | jq .; }

# Update dotfiles
updot() { cd ~/.dotfiles; git pull --rebase; ./install.sh; }

# Display the IP and geo information of the current machine
geoip() { curl -s www.telize.com/geoip | jq .; }
# Display only the IP
alias myip='curl ipaddr.ovh'

# Update a specific apt repo
# @help update_repo $repoName
update_repo() {
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/$1.list" \
    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
}

create_push_repo() {
  curl -s https://gist.githubusercontent.com/thbkrkr/d37ea4a4f912286ceb9b/raw/cce043b32a14b023868928a728aecf1f7c820b7b/prepare-pushgitrepo.sh | sh -s $1
}

##########################

# Source optional ~/.myzshrc
[ -f ~/.myzshrc ] && source ~/.myzshrc