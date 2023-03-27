#!/bin/sh

#paths can be relative or absolute
SOURCE="blog-tex"
OUTPUT="blog"
CSS="blog.css"

#getting vars
cd "$SOURCE" || {
	printf "Error: directory does not exist.\n"
	exit
}
TEXFILES="$(find . -name "*.tex")"

#INTENSE STREAM MANIPULATION
egrep "date|title" -m 3 *.tex | sed -e 's/\\date{//; s/:/ /; s/}//; /maketitle/d' | paste - - | sed -e 's/^/<a href="/; s/ \\title{/">/; s/.*tex//2g; s/\.tex/\.html/' | awk '{for (i=1; i<=NF-2; i++) printf "%s ", $i; print $NF}' | sed -e 's/\(.*\) /\1<\/a> - /; s/$/<br>/' | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' | sort -rn -k 1.8 -k 1.7 -k 1.5 -k 1.4 -k 1.2 -k 1.1 | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' > files.html

for file in $TEXFILES; do printf "Compiling \033[0;32m$(htlatex "$file" | grep "tex4ht -f" | sed 's|tex4ht -f/./||')\033[0m \n"; done
rm *.4ct *.4tc *.aux *.dvi *.idv *.lg *.log *.tmp *.xref

[ -f header.html ] || printf "Error: no header file present. Header files should contain everything for the blog index aside from the actual index of files.\n"
cat header.html files.html > index.html && rm files.html
printf '<link rel="stylesheet" href="blog.css">' | tee -a *.html > /dev/null
cd ..
mv $SOURCE/*.html $SOURCE/*.css "$OUTPUT"
cp "$OUTPUT/header.html" "$SOURCE"
