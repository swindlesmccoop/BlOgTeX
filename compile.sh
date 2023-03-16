#!/bin/sh

#getting vars
BLOG="example"
cd "$BLOG" || {
	printf "Error: directory does not exist.\n"
	exit
}
TEXFILES="$(find . -name "*.tex")"
rm -f "$(ls *.html *.css | sed '/header.html/d')"

#INTENSE STREAM MANIPULATION
egrep "date|title" -m 3 *.tex | sort -r | sed -e 's/\\date{//; s/:/ /; s/}//; /maketitle/d' | paste - - | sed -e 's/^/<a href="/; s/ \\title{/">/; s/.*tex//2g; s/\.tex/\.html/' | awk '{for (i=1; i<=NF-2; i++) printf "%s ", $i; print $NF}' | sed -e 's/\(.*\) /\1<\/a> - /; s/$/<br>/' > files.html

for file in $TEXFILES; do htlatex "$file"; done
rm *.4ct *.4tc *.aux *.dvi *.idv *.lg *.log *.tmp *.xref

[ -f header.html ] || printf "Error: no header file present. Header files should contain everything for the blog index aside from the actual index of files.\n"
cat header.html files.html > index.html