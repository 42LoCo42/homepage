#!/usr/bin/env bash
LC_COLLATE="" tree -Ff --prune --noreport stuff \
| sed 's| | |g' \
| awk -f processStuff.awk \
> tree.html
