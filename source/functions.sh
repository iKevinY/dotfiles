# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Build the most recently modified .tex file in the current directory
function xe() {
	if test -n "$(find . -maxdepth 1 -name '*.tex' -print -quit)"; then
		texfot xelatex $@ $(\ls -t *.tex | head -n1)
	else
		echo "No .tex files found in current directory."
	fi
}

# Open the most recently modified .pdf file in the current directory
function xo() {
	if test -n "$(find . -maxdepth 1 -name '*.pdf' -print -quit)"; then
		open $(\ls -t *.pdf | head -n1)
	else
		echo "No .pdf files found in current directory."
	fi
}

# Exports all variables present in an .env file
function expenv() {
	local envFile=${1:-".env"}
	export $(cat "$envFile" | xargs)
	echo "Exported variables found in \`$envFile\`"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar"
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	)

	local cmd=""
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli"
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz"
		else
			cmd="gzip"
		fi
	fi

	echo "Compressing .tar using \`${cmd}\`…"
	"${cmd}" -v "${tmpFile}" || return 1
	[ -f "${tmpFile}" ] && rm "${tmpFile}"
	echo "${tmpFile}.gz created successfully."
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@"
	}
fi

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1")
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a git.io short URL
function gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`"
		return 1
	fi
	curl -i http://git.io/ -F "url=${2}" -F "code=${1}"
	echo ''
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}"
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1")
	local gzipsize=$(gzip -c "$1" | wc -c)
	local ratio=$(echo "$gzipsize * 100/ $origsize" | bc -l)
	printf "orig: %d bytes\n" "$origsize"
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	else # pipe
		python -mjson.tool | pygmentize -l javascript
	fi
}

# All the dig info
function digall() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Escape UTF-8 characters into their 3-byte format
function escape() {
	printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u)
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo # newline
	fi
}

# Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
	perl -e "binmode(STDOUT, ':utf8'); print \"$@\""
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo # newline
	fi
}

# Get a character’s Unicode code point
function codepoint() {
	perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))"
	# print a newline unless we’re piping the output to another program
	if [ -t 1 ]; then
		echo # newline
	fi
}

# Add note to Notes.app (OS X 10.8)
# Usage: `note 'title' 'body'` or `echo 'body' | note`
# Title is optional
function note() {
	local title
	local body
	if [ -t 0 ]; then
		title="$1"
		body="$2"
	else
		title=$(cat)
	fi
	osascript >/dev/null <<EOF
tell application "Notes"
	tell account "iCloud"
		tell folder "Notes"
			make new note with properties {name:"$title", body:"$title" & "<br><br>" & "$body"}
		end tell
	end tell
end tell
EOF
}

# Add reminder to Reminders.app (OS X 10.8)
# Usage: `remind 'foo'` or `echo 'foo' | remind`
function remind() {
	local text
	if [ -t 0 ]; then
		text="$1" # argument
	else
		text=$(cat) # pipe
	fi
	osascript >/dev/null <<EOF
tell application "Reminders"
	tell the default list
		make new reminder with properties {name:"$text"}
	end tell
end tell
EOF
}

# `s` with no arguments opens the current directory in Sublime Text, otherwise
# opens the given location
function s() {
	if [ $# -eq 0 ]; then
		subl .
	else
		subl "$@"
	fi
}

# `o` with no arguments opens current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .
	else
		open "$@"
	fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}
