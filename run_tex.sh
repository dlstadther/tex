#!/bin/sh
set -eu

IMAGE=dlstadther/latex:tex

UserId=$(id -u)
GroupId=$(id -g)

#  --rm - cleanup
#  --user - same user as has ownership of mounted volume
#  --userns=keep-id - podman-specific to match runuser id
#  --net=none - remove container network, optional
#  --volume - mount CWD to /data (as configured in image) as read/write
exec podman run \
    --name=tex_build \
    --rm \
    --user="${UserId}:${GroupId}" \
    --userns=keep-id \
    --net=none \
    --volume="$PWD":/data:rw \
    "$IMAGE" \
    "$@"
