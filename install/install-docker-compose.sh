#!/bin/sh -eu
#
# Install Docker Compose (https://github.com/docker/compose)

DOCKER_COMPOSE_VERSION=1.10.1
DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64

is_up2date() {
    docker-compose -version 2> /dev/null \
        | grep -c "*$DOCKER_COMPOSE_VERSION)" > /dev/null
}

if ! is_up2date
then
    echo "Install docker-compose v$DOCKER_COMPOSE_VERSION..."
    sudo wget ${DOCKER_COMPOSE_URL} -O /usr/local/bin/docker-compose \
        && sudo chmod 755 /usr/local/bin/docker-compose
else
    echo "docker-compose v$DOCKER_COMPOSE_VERSION is up-to-date"
fi
