#!/usr/bin/env bash
rsync \
	-azvCP \
	--filter=':- .gitignore' \
	./ \
	bunny:INFRA/
