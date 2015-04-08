#!/bin/bash -u
#
# Clean Docker containers and images.
#
# This script assumes that the docker images are tagged with a version (like a git sha1) and 'latest'.
#
# WARNING: only 'latest' Docker images for the given repo are kept after a cleanup!
#
# Example of how to tag a Docker image with a version and 'latest':
#   $ docker build --rm -t $REPO/$NAME:$VERSION .
#   $ docker tag -f $REPO/$NAME:$VERSION $(ORG)/$NAME:latest
#

# The repo to use to filter images to delete
REPO=$1

# Utils functions
countContainers()       { docker ps -aq | wc -l; }
listStoppedContainers() { docker ps -a  | grep Exit | awk '{print $1}'; }
countmages()            { docker images | egrep -c "($REPO|none)"; }
listNotLatestImages()   { docker images | grep $REPO | grep -v latest | awk '{printf "%s:%s\n", $1, $2}'; }
listUntaggedImages()    { docker images -q -f dangling=true; }
log() { echo "[$(date +"%Y-%m-%dT%H:%M:%SZ")][docker-cleanup] $1"; }

totalContainers=$(countContainers)
totalImages=$(countmages)
log "Total containers: $totalContainers"
log "Total images: $totalImages"

#  Delete all stopped containers
containerIds=$(listStoppedContainers)
if [[ "$containerIds" != "" ]]; then
    log "Remove stopped containers..."
    docker rm $containerIds
fi

# Delete not latest images
oldImages=$(listNotLatestImages)
if [[ "$oldImages" != "" ]]; then
    log "Remove not latest images..."
    docker rmi -f $oldImages
fi

# Delete all untagged images
untaggedImages=$(listUntaggedImages)
if [[ "$untaggedImages" != "" ]]; then
    log "Remove untagged images..."
    docker rmi $untaggedImages
fi

newTotalContainers=$(countContainers)
newTotalImages=$(countmages)

log "---"
log "Containers deleted: $(expr $totalContainers - $newTotalContainers)"
log "Images deleted: $(expr $totalImages - $newTotalImages)"
log "---"
log "Total containers: $newTotalContainers"
log "Total images: $newTotalImages"
