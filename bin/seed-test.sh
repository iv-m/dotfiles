#!/bin/sh

set -exu

target="${1:?Usage: "$0" [user@]host}"

ssh-copy-id -i ~/.ssh/id_ed25519.pub  "$target"
ssh -t "$target" su - -c '"tail -n1 ~$USER/.ssh/authorized_keys >> .ssh/authorized_keys"' root
