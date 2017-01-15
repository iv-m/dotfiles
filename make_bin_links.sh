#!/bin/bash

set -exu

SRC_PATH="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))/bin"
DST_PATH="$HOME/bin"

ls "$SRC_PATH" | while read file; do
    [ -a "$DST_PATH/$file" ] || ln -s "$SRC_PATH/$file" "$DST_PATH/$file"
done
