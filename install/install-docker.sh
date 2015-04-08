#!/bin/sh
#
# Install Docker (https://github.com/docker/docker)

curl -sSL https://get.docker.com/ | sh

sudo usermod -aG docker $(whoami)
