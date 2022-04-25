#!/usr/bin/env bash
. "$DOCUMENT_ROOT/../utils"
. "$(basedir)/utils"
query_decode
post_decode

auth_failed() {
	echo "<h1>Authentication failed</h1>"
}

is_admin() {
	[ "$username" == "admin" ]
}

username="$(get_post "username")"
password="$(get_post "password")"
new_username="$(get_post "new_username")"
new_password="$(get_post "new_password")"

cat << EOF
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8"/>
		<title>Login</title>
		<link rel="stylesheet" href="/index.css"/>
	</head>
	<body style="display: none">
EOF
if [ -z "$username" ]; then
	cat << EOF
		<h1>Login</h1>
		<h5><a href="..">Back</a></h5>
		<h3>JS is not required for authentication, there are alternatives!</h3>
		Try logging in with <code>user:password</code> or <code>foo:bar</code>
		<hr/>
		<form method="post">
			Username: <input type="text" name="username"/><br/>
			Password: <input type="password" name="password"/><br/>
			<input type="submit" value="Login"/>
		</form>
EOF
elif try_login "$username" "$password"; then
	cat << EOF
		<h1>Logged in as $username</h1>
		<h5><a href="..">Back</a></h5>
		<form method="post">
			<h3>Actions:</h3>
			<input $(is_admin || echo 'type="hidden"') name="username" value="$username"/>$(is_admin && echo "<br/>")
			<input $(is_admin || echo 'type="hidden"') name="password" value="$(html_encode <<< "$password")"/>$(is_admin && echo "<br/>")
			<button type="submit" formaction="?action=get_date">Get date</button><br/>
			<button type="submit" formaction="?action=get_hash">Get my hash</button><br/>
			$(is_admin && echo '
				<hr/><h3>Admin options:</h3>
				Username: <input type="text" name="new_username"/><br/>
				Password: <input type="text" name="new_password"/><br/>
				<button type="submit" formaction="?action=admin_stats">Check stats</button><br/>
				<button type="submit" formaction="?action=admin_accounts_list">List accounts</button><br/>
				<button type="submit" formaction="?action=admin_accounts_register">Register account</button><br/>
				<button type="submit" formaction="?action=admin_accounts_delete">Delete account</button><br/>
				<input  type="file" id="file" name="filename"/>
				<button type="submit" formaction="?action=admin_upload_file">Upload file</button><br/>
				<hr/>
			')
		</form>
		<form>
		<button type="submit">Logout</button><br/>
		</form>
EOF
	action="$(get_query action)"
	[ -n "$action" ] && {
		echo "Selected action: $action<br>Result:<pre id=\"action_result\">"
		if [[ "$action" =~ admin_.+ ]] && ! is_admin; then
			echo "You are not an admin!"
		else
			case "$action" in
				get_date) date ;;
				get_hash) db get "$username/password";;
				admin_stats)
					uptime
					free -h
					pstree -auU
				;;
				admin_accounts_list) db get . | tail -n+2 | sed 's|^..||' | sort ;;
				admin_accounts_register)
					register "$new_username" <<< "$new_password" 2>&1
					echo "<br/>Exit code: $?"
				;;
				admin_accounts_delete)
					db del "$new_username" 2>&1
					echo "<br/>Exit code: $?"
				;;
			esac
		fi
		echo "</pre>"
	}
else
	auth_failed
fi
echo "</body></html>"
