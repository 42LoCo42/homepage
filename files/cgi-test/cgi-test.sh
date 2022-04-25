#!/bin/bash
. "$DOCUMENT_ROOT/../utils"
query_decode
get_query upload >/dev/null
is_upload=$(($? == 0))
((is_upload)) || post_decode

cat << EOF
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8"/>
		<link rel="stylesheet" href="/index.css"/>
	</head>
	<body style="display: none">
EOF

echo "you are $REMOTE_ADDR:$REMOTE_PORT doing a $REQUEST_METHOD<br>"
echo "<hr>"

echo "headers:<br><pre>"
list_headers | sort | while read -r i; do
	echo "$i = $(get_header "$i" | html_encode)"
done
echo "</pre><hr>"

echo "GET options:<br><pre>"
list_query | while read -r i; do
echo "$i = $(get_query "$i" | html_encode)"
done
echo "</pre><hr>"

if ((is_upload)); then
	echo "POST body:<br><pre>"
	# tee "/tmp/out" | html_encode
	html_encode
else
	echo "POST options:<br><pre>"
	list_post | while read -r i; do
		echo "$i = $(get_post "$i" | html_encode)"
	done
fi
echo "</pre><hr>"

echo "All variables:<br><pre>"
printenv | sort | grep -v "/srv/http/root"
echo "</pre><hr>"

cat << EOF
	</body>
</html>
EOF
