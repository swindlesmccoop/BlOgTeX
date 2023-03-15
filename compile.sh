#!/bin/sh

#getting vars
BLOG="example"
cd "$BLOG" || {
	printf "Error: directory does not exist.\n"
	exit
}
TEXFILES="$(find . -name "*.tex")"

#INTENSE STREAM MANIPULATION
egrep "date|title" -m 3 *.tex | sort -r | sed -e 's/\\date{//; s/:/ /; s/}//; /maketitle/d' | paste - - | sed -e 's/^/<a href="/; s/ \\title{/">/; s/.*tex//2g; s/\.tex/\.html/' | awk '{for (i=1; i<=NF-2; i++) printf "%s ", $i; print $NF}' | sed -e 's/\(.*\) /\1<\/a> - /; s/$/<br>/' > files.html

for file in $TEXFILES; do
  htlatex "$file"
done
ls | rm $(sed -e '/html/d; /css/d')

[ -f header.html ] || printf "Error: no header file present. Header files should contain everything for the blog index aside from the actual index of files.\n"
cat header.html files.html > index.html