#!/usr/bin/env bash

# read -r d m y <<< "$(date +"%d %m %Y")"
# age=$((y - 2002))
# if ((m < 11 || (m == 11 && d < 4))); then
# 	((age--))
# fi

cat << EOF
<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8"/>
		<title>ZHS Homepage</title>
		<link rel="stylesheet" href="/index.css"/>
	</head>
	<body style="display: none">
		<div style="display: grid; grid-template-columns: 1fr auto 1fr;">
			<div>
				<h1>About me</h1>
				<p>
					I am Eleonora Schumacher, a 19 year old undergraduate student at the
					<a href="https://www.hochschule-stralsund.de" target="_blank">Hochschule Stralsund</a>,<br/>
					where I study IT-Security and Mobile Systems.
				</p><p>
					In my free time, I enjoy programming in a variety of languages, but usually backend/OS-level stuff.<br/>
					I use Linux as my main OS, but sometimes I play with different UNIX(-like) kernels like Plan 9 or BSD.<br/>
				</p><p>
					I am autistic, but do not view myself as medically disabled.<br/>
					Instead, I advocate for the implementation of the <a href="https://en.wikipedia.org/wiki/Social_model_of_disability" target="_blank">social model of disability</a>.<br/>
					I am also aromantic and asexual and greatly value LGBTQIA+/GSRM rights.
				</p>
				<p>
					Approximately during December 2021, I have realized that I am a woman.
					I take a lot of pride in my new identity. My pronouns are she/her.
					Trans rights are human rights!
					<img class="badge" alt="The trans flag" src="/assets/trans.png"/>
				</p>
			</div>
			<div>
				<h1>Available Services</h1>
				<form method="get">
EOF
find . \
	-mindepth 2 -maxdepth 2 \
	-name 'index.*' \
| sed 's|^\./||; s|/[^/]*$||' \
| uniq \
| while read -r dir; do
	echo "<button formaction=\"$dir\">"
	[ -f "$dir/favicon.ico" ] && echo "<img alt=\"$dir\" src=\"$dir/favicon.ico\"/>"
	echo "<span>$dir</span></button>"
done

neofetch="$(
	sed "
		s|UPTIME|$(uptime -p | tail -c+4)|;
		s|MEMORY|$(free -h | awk 'NR == 2 {print $3 "B / " $2 "B"}')|;
	" "$DOCUMENT_ROOT/../caches/neofetch"
)"

cat << EOF
				</form>
			</div>
			<div>
				<h1>Current projects</h1>
				<ul>
					<li>
						(PLANNED) My own programming language. Features:
						<ul>
							<li>Functional and imperative</li>
							<li>Relatively low-level, just a little bit above C</li>
							<li>No garbage collector; memory management via lifetime checks</li>
							<li>
								<a href="https://en.wikipedia.org/wiki/Homoiconicity" target="_blank">
									Homoiconicity
								</a>
								and metaprogramming capabilities like Lisp.
							</li>
						</ul>
						<a href="/foo/sprache.html">Current list of ideas (in German)</a>
					</li>
					<li>
						A secure communications library, as a minimalistic alternative to TLS:
						<a href="https://github.com/42LoCo42/zeolite" target="_blank">zeolite</a><br/>
						Still working on a better multi-client support...
					</li>
					<li>
						A REPL for C, with eventual support for variables and autocompletion:
						<a href="https://github.com/42LoCo42/c-repl" target="_blank">c-repl</a>
					</li>
				</ul>
			</div>
		</div>
		<hr/>

		<h1>Sysinfo</h1>
		<div style="display: grid; grid-template-columns: auto 1fr 1fr 1fr;">
			<div style='grid-column: 1 / 3;'>
				<h3>Neofetch</h3>
			</div>
			<div style='grid-column: 3;'>
				<h3>Packages</h3>
			</div>
			<div>
				<h3>Git-Log</h3>
			</div>
			<div style="margin-right: 15px;">
				<pre>
$(< "$DOCUMENT_ROOT/../caches/logo")
				</pre>
			</div>
			<div>
				<pre>
$neofetch
				</pre>
			</div>
			<div>
				<pre>
$(< "$DOCUMENT_ROOT/../caches/packages")
				</pre>
				<h3>Links</h3>
				<ul>
					<li><a href="https://github.com/42LoCo42" target="_blank">Github</a>
					(<a href="https://github.com/42LoCo42/homepage" target="_blank">this page</a>)</li>
					<li><a href="https://aur.archlinux.org/packages/?K=42LoCo42&amp;SeB=m" target="_blank">AUR packages</a></li>
					<li>
						<a href="https://keys.openpgp.org/vks/v1/by-fingerprint/C743EE077172986F860FC0FE2F6FE1420970404C">
							My PGP key (Leon Schumacher &lt;leonsch@protonmail.com&gt;)
						</a>
					</li>
					<li><a href="https://kikuo.jp/" target="_blank">Good music</a></li>
				</ul>
			</div>
			<pre style="height: 20em; overflow: scroll; border: solid 1px var(--color-7);">
$(< "$DOCUMENT_ROOT/../caches/gitlog")
			</pre>
		</div>
		<hr/>
EOF
#		<div style="display: grid; grid-template-columns: auto auto;">
#			<div>
#					<iframe
#						style="
#							border: none;
#							overflow: hidden;
#							width: 301px;
#							height: 286px;
#						"
#						src="https://github-readme-stats.vercel.app/api/top-langs/?username=42LoCo42&amp;theme=gruvbox"
#					></iframe>
#			</div>
#		</div>
#		<hr/>
cat << EOF
		<div style="display: grid; grid-template-columns: auto auto;">
			<div>
				<a href="https://validator.w3.org/nu/?doc=https%3A%2F%2F42loco42.duckdns.org%2F" target="_blank">
					<img class="badge" alt="HTML5 Valid" src="/assets/html5-validator-badge.png"/>
				</a>
				<img class="badge" alt="100% cookie free!" src="/assets/nocookie.png"/>
				<img class="badge" alt="AroAce flag" src="/assets/flag.png"/>
				<img class="badge" alt="This is a safe space" src="/assets/safespace.png"/>
				This is a safe space for everyone!
			</div>
			<div>
				2022-04-25 - Migration to lighttpd complete!
			</div>
		</div>
	</body>
</html>
EOF
