#!/bin/sh -eu
#
# Install docker-compose (https://github.com/docker/compose)

DOCKER_COMPOSE_VERSION=1.2.0
DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64

is_up2date() {
    docker-compose -version 2> /dev/null \
        | grep -c "^docker-compose version $(echo $DOCKER_COMPOSE_VERSION | sed 's/-.*//')" > /dev/null
}

if ! is_up2date
then
    echo "Install docker-compose v$DOCKER_COMPOSE_VERSION..."
    sudo wget ${DOCKER_COMPOSE_URL} -O /usr/bin/docker-compose \
        && sudo chmod 755 /usr/bin/docker-compose
else
    echo "docker-compose v$DOCKER_COMPOSE_VERSION is up-to-date"
fi
