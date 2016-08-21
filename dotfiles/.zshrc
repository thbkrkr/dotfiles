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
alias ap='ansible-playbook'
alias c='clear'
alias d='docker'
alias g='git'
alias h='history'
alias m='make'
alias s='ssh'
alias dc='docker-compose'
alias dm='docker-machine'
alias sb='sensible-browser'
alias tf='terraform'

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
alias drud="docker run -d -P"
alias drui="docker run --rm -P -ti"
dim()  { docker images | grep $@; }

alias dclean='~/bin/docker-cleanup.sh'
alias dcleanvol='~/bin/docker-cleanup-volumes.sh'
drm()  { docker rm $(docker ps -qa); }
drme() { docker rm $(docker ps -qa --filter 'status=exited'); }
drmi() { docker rmi $(docker images -q --filter "dangling=true"); }
dvrm() { docker volume ls -qf dangling=true | xargs -r docker volume rm; }
dka() { docker rm -f $(docker ps -aq); }
dps() { docker ps -a --format 'table{{.Names}}\t{{.Status}}'; }
dpsm() { docker ps -a --format 'table{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}'; }

dip()  { docker inspect --format '{{ .NetworkSettings }}' "$@"; }
dpid() { docker inspect --format '{{ .State.Pid }}' "$@"; }

dexecsh()  { docker exec -ti $@ sh }
dexecbash() { docker exec -ti $@ bash }
dexeczsh() { docker exec -ti $@ zsh }

dstats() { docker stats $(docker ps | grep -v CON | sed "s/.*\s\([a-z].*\)/\1/" | awk '{printf $1" "}'); }

# Docker machine aliases
dme()  { eval $(docker-machine env --shell zsh $1); }
dmes() { eval $(docker-machine env --shell zsh --swarm $1); }

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

# Create a Git repo ready to accept push and with a post-receive to checkout the working directory
create_push_repo() {
  curl -s https://gist.githubusercontent.com/thbkrkr/d37ea4a4f912286ceb9b/raw/cce043b32a14b023868928a728aecf1f7c820b7b/prepare-pushgitrepo.sh | sh -s $1
}

# Tail and grep syslog as sudo
stf() {
  sudo tail -f /var/log/syslog  | grep $1
}

# Source a .env file in 'VAR=value' format (used in the docker world)
sourcenv() {
  if [[ "$1" != "" ]]; then
    export $(cat $1 | xargs)
  else
    while read envfile; do
      echo "source $envfile"
      export $(cat $envfile | xargs)
    done < <(find . -name "*.env")
  fi
}

##########################

# Source optional ~/.myzshrc
[ -f ~/.myzshrc ] && source ~/.myzshrc
