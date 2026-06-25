
# Enable completion
autoload -Uz compinit
compinit

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Case-insensitive completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|=*' \
    'l:|=*'

# Interactive menu selection
zstyle ':completion:*' menu select

# Make cd complete recursively
setopt AUTO_CD

source <(kubectl completion zsh)
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

export PATH=$PATH:~/bin:~/go/bin:~/.local/bin
export GH_TOKEN=$(cat ~/.gh_token)

export HOMEBREW_NO_ENV_HINTS=1

fortune | cowsay | lolcat

##########################

# In $HOME, point `git` (and all g* shortcuts) at the dotfiles bare repo
chpwd() {
  if [[ "$PWD" == "$HOME" ]]; then
    alias git='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  else
    unalias git 2>/dev/null || true
  fi
}
chpwd  # run once at shell start

alias dv='devctl'
source <(devctl completion zsh)

##########################

alias bi='brew install -y'

# Tiny aliases
alias c='clear'
alias d='docker'
alias e='echo'
alias g='git'
alias h='history'
alias m='make'
alias s='ssh'
alias tf='terraform'
alias k='kubectl'
compdef k=kubectl
compdef g=git

export LS_COLORS="ex=01;32:${LS_COLORS}"
alias ls='ls --color=auto'
alias l='ls -1'
alias ll='ls -al'

# Git aliases/func
alias gst='git status'
alias gpr='git pull --rebase'
alias grrh='git reset --hard HEAD'
alias gcdf='git clean -df'
alias gcam='git commit --amend'
alias gcamne='git commit --amend --no-edit'
alias grpo='git remote prune origin'
alias gspp='git stash && git pull --rebase && git stash pop'
alias glg='git lg --stat -C -4'

# Docker aliases/func
dps()  { docker ps -a --format 'table{{.Names}}\t{{.Status}}'; }
dpsa() { docker ps -a --format 'table{{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}'; }
dim()  { docker images | grep $@; }
alias xd='xargs -r docker'
drmc() { docker ps -qa --filter 'status=dead' --filter 'status=exited' | xd rm; }
drmcg() { docker ps -a | grep "${@:-a}" | awk '{print $1}' | xargs -n1 docker rm -f; }
drmi() { docker images -q --filter "dangling=true" | xd rmi; }
drmig() { docker images | grep "${@:-a}" | awk '{printf "%s:%s\n", $1, $2}' | xargs -n1 docker rmi -f; }
drmv() { docker volume ls -q | xd volume rm; }
drmn() { docker network ls | awk '{print $1,$2}' | tail -n +2 | egrep -Ev "( docker_gwbridge$| bridge$| host$| none$| ingress$)" | awk '{print $1}' | xd network rm; }
drms() { docker service ls | tail -n +2 | awk '{print $2}' | xd service rm; }
dprune() { docker system prune -f }
drmall() { drmc; drmi; drmv; drmn; }
dkillall()  { docker ps -aq | xd rm -f; }
dstopall()  { docker ps -aq | xargs -r docker stop; }
dip()  { docker inspect --format '{{ .NetworkSettings }}' "$@"; }
dpid() { docker inspect --format '{{ .State.Pid }}' "$@"; }
dsh()  { docker exec -ti $@ sh }
dbash() { docker exec -ti $@ bash }
dzsh() { docker exec -ti $@ zsh }
dstats() { docker stats $(docker ps | grep -v CON | sed "s/.*\s\([a-z].*\)/\1/" | awk '{printf $1" "}'); }

# Apt
alias get='sudo apt-get install -y'
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
  local length=${1:-20}
  cat /dev/urandom | tr -dc 'a-zA-Z0-9&@#!%?;:-[]{}' | fold -w $length | head -1
}

# @help always $sleepDuration $cmd
always() { duration=$1 && shift; while true; do $@; sleep $duration; done; }

# @help grepcode $path $fileExtension $grepRegexp
grepcode() { find $1 -name "*.$2" | xargs grep -Hn $3; }

# cURL functions
curlv() { curl $@ -w "\n@status=%{response_code}\n@time=%{time_total}\n"; }
cl()    { curl -s localhost:$@; }
jc()    { curl -s $@ | jq .; }
jcl()   { curl -s localhost:$@ | jq .; }
kurl() {
  curl -sSL --connect-timeout 3 $@ -o /dev/null \
    -w '{"url":"%{url_effective}","status":"%{http_code}","time":"%{time_total}"}\n'
}

# Display only the IP
myip() {
  curl -s ipaddr.ovh
}

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
stfg() {
  sudo tail -f /var/log/syslog  | grep $1
}

msg() { echo -n '{"user":"'$USER'@'$(hostname)'", "message":"'$@'"}'; }

# Source a .env file in 'VAR=value' format (used in the docker world)
sourcenv() {
  if [[ "$1" != "" ]]; then
    export $(cat $1 | xargs)
  else
    while read envfile; do
      echo "source $envfile"
      export $(cat $envfile | grep -vE "(^#|^\s*$)" | xargs)
    done < <(find . -name "*.env")
  fi
}

# Make subdirectories and move into them right away
mdir(){
  mkdir -p $1; cd $1
  echo "You are now in $PWD"
}

# found at http://stackoverflow.com/a/245724/452140
uup(){
  LIMIT=$1
  if [ -z "$LIMIT" ]; then
    LIMIT=1
  fi
  P=$PWD
  for ((i=1; i <= LIMIT; i++)); do
    P=$P/..
  done
  cd $P
  echo "You are now in $PWD"
}

# Configure git user
gitcfg(){
  if [ "$#" -lt "2" ] ; then
      echo "Usage: gitcfg <user> <email>"
      return 1
  fi
  declare username=$1 email=$2
  git config user.name "$username"
  git config user.email "$email"
}

# Search files given a pattern in a directory
# @what  pattern
# @where path
ff(){
  what=$1
  if [ $2 ]; then
    where=$2
  else
    where=""
  fi
  # redirect the stderr to stdout, grep both to exclude 'permission denied'
  # assumes we don't want to find a file that's called "permission denied".
  find $where -iname "$what" 2>&1 | grep -v 'Permission denied'
}

# --- xclip

# Copy stdin in the clipboard
xclip() {
  echo "$@" | xclip -selection c
}

# Copy current directory path in the clipboard
cppwd(){
  echo "cd $(pwd)" | xclip
}

# Copy last command in the clipboard
cplastcmd(){
  echo -n $(fc -nl -1) | tr -d '\n' | xclip
}

# Copy last command ouput in the clipboard
cplastcmdout(){
  cmd=$(fc -nl -1 | tr -d '\n')
  $cmd | xclip -sel clipboard
}
