processStuff:
	LC_COLLATE= tree -Ff --prune --noreport stuff \
	| sed 's| | |g' \
	| ./processStuff.awk \
	> tree.html
