#!/usr/bin/env bash
GOARCH=arm64 CGO_ENABLED=0 go build .
rsync -azvLP --delete \
	element.config.json \
	index.html \
	matrix.html \
	new-site \
	static \
	stuff \
	tree.html \
	bunny:homepage/

ssh bunny "cp homepage/element.config.json /var/www/html/element/config.json"
