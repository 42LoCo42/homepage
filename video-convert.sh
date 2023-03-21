#!/usr/bin/env bash
ffmpeg \
	-i "$1" \
	-vcodec libx264 \
	-pix_fmt yuv420p \
	-profile:v baseline \
	-level 3 \
	-movflags faststart \
	"tmp.mp4" && mv "tmp.mp4" "$1"
