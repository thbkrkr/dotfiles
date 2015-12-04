#!/bin/bash -eu
#
# Add an entry in ~/.ssh/config for a VM created with docker-machine

VM=$1

ip=$(docker-machine ip $VM)
user=$(docker-machine inspect $VM | jq -r .Driver.SSHUser)

if [ $(grep -c "Host $VM" ~/.ssh/config) -eq 0 ]
then
  echo "Host $VM" >> ~/.ssh/config
  echo "  User $user" >> ~/.ssh/config
  echo "  Hostname $ip" >> ~/.ssh/config
  echo "  IdentityFile /home/$(whoami)/.docker/machine/machines/$VM/id_rsa" >> ~/.ssh/config
else
  echo "SSH is already configured for the machine $VM"
fi