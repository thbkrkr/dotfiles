#!/bin/sh -eu
#
# Install Docker (https://github.com/docker/docker)

is_installed() {
    which docker > /dev/null 2>&1
}

if ! is_installed
then
    echo "Install docker..."
    curl -sSL https://get.docker.com/ | sh
else
    echo "docker is installed..."
    docker version
fi

sudo usermod -aG docker $(whoami)