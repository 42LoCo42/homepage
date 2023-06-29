#!/usr/bin/env bash
rsync \
	-azvCP \
	-f '+ /.env' \
	-f ':- .gitignore' \
	--delete \
	./ \
	bunny:INFRA/ \
	"$@"
