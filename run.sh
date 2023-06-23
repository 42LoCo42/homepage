#!/usr/bin/env bash
set -euo pipefail
cmd="$1"
shift
printf '%s\n' "$@" \
| xargs -I% make -C % "$cmd"
