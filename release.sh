#!/bin/sh
set -eu

# Creates and pushes the release tag for today: resume-YYYY.MM.DD, or resume-YYYY.MM.DD.N if that tag exists.
# CI builds the PDF and publishes the GitHub Release when the tag arrives.
# DRY_RUN=1 prints the tag and does not create or push it.

Remote="origin"
Branch="main"
Prefix="resume-"

fail() {
    echo "# ERROR: $*" >&2
    exit 1
}

Current=$(git rev-parse --abbrev-ref HEAD)
[ "$Current" = "$Branch" ] || fail "check out '${Branch}' first (current branch: ${Current})"

[ -z "$(git status --porcelain)" ] || fail "the working tree has changes; commit or remove them first"

git fetch --quiet "$Remote" "$Branch"
[ "$(git rev-parse HEAD)" = "$(git rev-parse FETCH_HEAD)" ] \
    || fail "local '${Branch}' is not the same as ${Remote}/${Branch}; pull or push first"

Base="${Prefix}$(date +%Y.%m.%d)"

# Same-day tags from the local repo and from the remote.
Existing=$(
    {
        git tag --list "${Base}*"
        git ls-remote --tags --refs "$Remote" "refs/tags/${Base}*" | sed 's|.*refs/tags/||'
    } | sort -u
)

tag_exists() {
    printf '%s\n' "$Existing" | grep -qxF "$1"
}

Tag="$Base"
N=0
while tag_exists "$Tag"; do
    N=$((N + 1))
    Tag="${Base}.${N}"
done

echo "# Release tag: ${Tag} (commit $(git rev-parse --short HEAD))"

if [ "${DRY_RUN:-0}" = "1" ]; then
    echo "# DRY_RUN=1: no tag created, nothing pushed"
    exit 0
fi

git tag --annotate "$Tag" --message "Resume ${Tag#"$Prefix"}"
git push "$Remote" "refs/tags/${Tag}"
echo "# Pushed ${Tag}. CI builds the PDF and publishes the release."
