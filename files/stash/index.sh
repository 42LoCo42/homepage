#!/usr/bin/env bash
name="$([[ "${BASH_SOURCE[0]}" =~ secure ]] && printf "Secure ")Stash"

cat << EOF
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8"/>
		<title>$name</title>
		<link rel="stylesheet" href="/index.css"/>
	</head>
	<body style="display: none">
		<h1>$name</h1>
		<h5><a href="..">Back</a></h5>
		Miscellaneous things
		<hr/>
		<h3>&lt;no extension&gt;</h3>
EOF

mapfile -t files <<< "$(
	find "$(dirname "${BASH_SOURCE[0]}")" -mindepth 1 \
	| sed -E '
		/index.sh$/d;
		s|.*/.*/||;
		s|(.*)\.([^.]*)$|.\2\1|;
		s|^([^]+)$|\1|;
	' \
	| sort -f
)"
last_ext=
for f in "${files[@]}"; do
	IFS='' read -r ext name <<< "$f"
	[ "$ext" != "$last_ext" ] && echo "<hr/><h3>$ext</h3>" && last_ext="$ext"
	echo "<a href='${name// /%20}$ext'>$name$ext</a><br/>"
done

cat << EOF
	</body>
</html>
EOF
