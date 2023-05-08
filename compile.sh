#!/bin/sh

#paths must be absolute
SOURCE="$HOME/workspace/blogtex/blog-tex"
OUTPUT="$HOME/workspace/blogtex/blog-html"
CSS="/css/blog.css"
mkdir -p "$SOURCE" "$OUTPUT"

#cleanup
rm -f "$OUTPUT/*"

#getting vars
cd "$SOURCE"
TEXFILES="$(ls -1 *.tex | sed 's/\.tex//g')"

#INTENSE STREAM MANIPULATION
egrep "date|title" -m 3 *.tex | sed -e 's/\\date{//; s/:/ /; s/}//; /maketitle/d' | paste - - | sed -e 's/^/<a href="/; s/\\title{/">/; s/.*tex//2g; s/\.tex/\.html/' | awk '{for (i=1; i<=NF-2; i++) printf "%s ", $i; print $NF}' | sed -e 's/\(.*\) /\1<\/a> - /; s/$/<br>/' | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' | sort -rn -k 1.8 -k 1.7 -k 1.5 -k 1.4 -k 1.2 -k 1.1 | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' > $SOURCE/files.html

for file in $TEXFILES; do
	printf "Compiling \033[0;32m"$file".tex\033[0m\n"
	pandoc "$file.tex" -o "$OUTPUT/$file.html" --css=$CSS
done

cat $SOURCE/header.html $SOURCE/files.html > $OUTPUT/index.html
rm $SOURCE/files.html
