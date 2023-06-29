#!/usr/bin/env bash
rsync \
	-azvCP \
	--filter=':- .gitignore' \
	--delete \
	./ \
	bunny:INFRA/
