#!/bin/sh -eu
#
# Install Crane (https://github.com/michaelsauter/crane)

CRANE_VERSION=1.0.0
CRANE_URL=https://github.com/michaelsauter/crane/releases/download/v${CRANE_VERSION}/crane_linux_amd64

is_up2date() {
    crane version 2> /dev/null | grep -c "^v${CRANE_VERSION}$" > /dev/null
}

if ! is_up2date
then
    echo "Install crane v$CRANE_VERSION..."
    sudo wget ${CRANE_URL} -O /usr/bin/local/crane \
        && sudo chmod 755 /usr/bin/local/crane
else
    echo "crane v$CRANE_VERSION is up-to-date"
fi
