#!/bin/sh
set -eu

# ENGINE: docker or podman. IMAGE: image to run.
ENGINE="${ENGINE:-docker}"
IMAGE="${IMAGE:-dlstadther/latex:tex}"

case "$ENGINE" in
    docker) UserNs="" ;;
    podman) UserNs="--userns=keep-id" ;;
    *) echo "ENGINE must be docker or podman, got: $ENGINE" >&2; exit 1 ;;
esac

UserId=$(id -u)
GroupId=$(id -g)

#  --rm - cleanup
#  --user - same user as has ownership of mounted volume
#  --userns=keep-id - podman only, to match runuser id
#  --net=none - remove container network
#  --volume - mount CWD to /data (as configured in image) as read/write
#  --env - pass SOURCE_DATE_EPOCH and FORCE_SOURCE_DATE from the host only if they are set;
#          they fix the dates and document ID in the PDF
# UserNs is unquoted on purpose: empty for docker, one flag for podman.
# shellcheck disable=SC2086
exec "$ENGINE" run \
    --rm \
    --user="${UserId}:${GroupId}" \
    $UserNs \
    --net=none \
    --env=SOURCE_DATE_EPOCH \
    --env=FORCE_SOURCE_DATE \
    --volume="$PWD":/data:rw \
    "$IMAGE" \
    "$@"
