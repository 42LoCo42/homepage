FROM searxng/searxng:2023.6.23-2e4a4351

RUN \
	mkdir -p /etc/searxng && \
	chown -R nobody:nogroup /etc/searxng && \
	sed -i \
		's|su-exec searxng:searxng ||' \
		/usr/local/searxng/dockerfiles/docker-entrypoint.sh
