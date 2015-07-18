#!/bin/sh -eu
#
# Install Docker (https://github.com/docker/docker)

is_installed() {
    which docker > /dev/null 2>&1
}

join_group() {
  if [ $(grep -c "docker.*$(whoami)" /etc/group) -ne 1 ]; then
    sudo usermod -aG docker $(whoami)
  fi
}

if ! is_installed
then
  echo "Install Docker..."
  curl -sSL https://get.docker.com/ | sh
  join_group
else
  join_group # in case
  echo "Docker is installed..."
  docker version
fi
