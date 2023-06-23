#!/usr/bin/env bash
set -euo pipefail
LC_COLLATE="" tree -Ff --prune --noreport stuff \
| sed 's| | |g' \
| awk -f processStuff.awk \
> tree.html
