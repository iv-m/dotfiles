#!/bin/bash

set -eu ${DEBUG:+-x}

package="$1"
first_char="$(echo "$package" | head -c1)"
branch="${2:-sisyphus}"
alias="${alias:-git.alt}"

echo "Cloning $package for $branch from $alias"


has_branch () {
    local head
    head=$(git ls-remote "$1" "refs/heads/$2" 2>/dev/null)
    [ -n "$head" ] || return 1
}

try_clone () {
    local what="$1"
    local remote="$alias:/$what/$first_char/$package.git"

    if has_branch "$remote" "$branch"; then
        git clone -o "$what" "$remote"
        cd "$package" && git checkout "$branch" && exit 0
    fi
    return 1
}

try_clone gears || echo "failed to clone gears"
try_clone srpms || echo "failed to clone srpms. what now?"
exit 1
