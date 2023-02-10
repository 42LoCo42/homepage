#!/usr/bin/env bash
GOARCH=arm64 CGO_ENABLED=0 go build .
rsync -azvP --delete \
	static \
	index.html \
	new-site \
	bunny:homepage/
