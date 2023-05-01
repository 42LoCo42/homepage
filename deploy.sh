#!/usr/bin/env bash
cp "$HOME/.config/emacs/init.html" "static/emacs/"
make
GOARCH=arm64 CGO_ENABLED=0 go build .
rsync -azvLP --delete \
	--exclude="static/foo/" \
	element.config.json \
	./*.html \
	new-site \
	static \
	stuff \
	bunny:homepage/

ssh bunny "cp homepage/element.config.json /var/www/html/element/config.json"
