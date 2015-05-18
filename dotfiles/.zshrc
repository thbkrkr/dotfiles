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

export HISTSIZE=20000

export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

##########################

# Tiny aliases
alias c='clear'
alias d='docker'
alias dm='docker-machine'
alias dc='docker-compose'
alias g='git'
alias h='history'
alias m='make'
alias s='ssh'
alias cr='crane'

# Git aliases
alias gs='git status'
alias gst='git status'
alias gpr='git pull --rebase'
alias grrh='git reset --hard HEAD'
alias gcdf='git clean -df'
alias gcam='git commit --amend'
alias gcamne='git commit --amend --no-edit'
alias gspp='git stash && git pull --rebase && git stash pop'
gri() { git rebase -i HEAD~$1; }
alias glg='git lg --stat -C -4'

# Docker aliases
db() { docker build -t="$1" .; }
drm() { docker rm $(docker ps -q -a); }
dri() { docker rmi $(docker images -q --filter "dangling=true"); }
dgo() { docker exec -ti $@ bash }
dip() { docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"; }
dpid() { docker inspect --format '{{ .State.Pid }}' "$@"; }
dstats() { docker stats $(docker ps | grep -v CON | sed "s/.*\s\([a-z].*\)/\1/" | awk '{printf $1" "}'); }
alias dkd="docker run -d -P"
alias dki="docker run -t -i -P"
alias dclean='~/bin/docker-cleanup.sh'
dim() { docker images | grep $@; }

# Others aliases
alias tmux='tmux -2'

# Apt
alias get='sudo apt-get install -y'
alias search='sudo apt-cache search'

# Display listened ports
alias wholisten='sudo netstat -antulp | grep LISTE'

# @help always $cmd $sleepDuration
always() { while true; do "$1"; sleep $2; done; }

# @help grepcode $path $fileExtension $grepRegexp
grepcode() { find $1 -name "*.$2" | xargs grep -Hn $3; }

# curl with response code and total time
cuurl() { curl $@ -w "\n@status=%{response_code}\n@time=%{time_total}\n"; }

# curl and format response with JQ
jc() { curl -s "$1" | jq .; }

# curl localhost
cl() { curl -s localhost:$@; }
jcl() { curl -s localhost:$@ | jq .; }

# update dotfiles
updot() { cd ~/.dotfiles; git pull --rebase; ./install.sh; }

# Display the IP and geo information of the current machine
geoip() { curl -s www.telize.com/geoip | jq .; }

# update a specific apt repo
# @help update_repo docker
update_repo() {
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/$1.list" \
    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
}

create_push_repo() {
  curl -s https://gist.githubusercontent.com/thbkrkr/d37ea4a4f912286ceb9b/raw/cce043b32a14b023868928a728aecf1f7c820b7b/prepare-pushgitrepo.sh | sh -s $1
}

devbox() {
  d run -ti \
    -v $(pwd):/work \
    -v /usr/bin/docker:/usr/bin/docker:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    krkr/devbox
}

##########################

# Source optional ~/.myzshrc
[ -f ~/.myzshrc ] && source ~/.myzshrc
