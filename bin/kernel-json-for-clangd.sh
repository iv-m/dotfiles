#!/bin/bash

set -xue

[ -f .config ]

./scripts/clang-tools/gen_compile_commands.py "$@"

# some cleanups
# - remove options that are not supported by clang
#   and should not affect parsing
# - rewrite target into something clang can digest
sed -i \
    -e 's/-fno-allow-store-data-races//g'   \
    -e 's/-mstack-protector-guard\S\+//g'    \
    -e 's/-fconserve-stack//g'              \
    -e 's/-ftrivial-auto-var-init=\S\+//g'   \
    -e 's/rv64ima\S\+/rv64gc/g'             \
    compile_commands.json
