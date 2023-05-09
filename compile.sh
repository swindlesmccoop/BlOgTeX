#!/bin/sh

#paths must be absolute
SOURCE="/usr/share/blog-tex"
OUTPUT="/usr/share/blog-html"
CSS="/css/blog.css"
BLOGURL="https://swindlesmccoop.xyz/blog"
mkdir -p "$SOURCE" "$OUTPUT"

#cleanup
rm -f "$OUTPUT/*"

#getting vars
cd "$SOURCE"
TEXFILES="$(ls -1 *.tex | sed 's/\.tex//g')"

#INTENSE STREAM MANIPULATION
egrep "date|title" -m 3 *.tex | sed -e 's/\\date{//; s/:/ /; s/}//; /maketitle/d' | paste - - | sed -e 's/^/<a href="/; s/\\title{/">/; s/.*tex//2g; s/\.tex/\.html/' | awk '{for (i=1; i<=NF-2; i++) printf "%s ", $i; print $NF}' | sed -e 's/\(.*\) /\1<\/a> - /; s/$/<br>/' | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' | sort -r -k1.7,1.10 -k1.1,1.2 -k1.4,1.5 | awk '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' > $SOURCE/files.html
cat $SOURCE/header.html $SOURCE/files.html > $OUTPUT/index.html
rm $SOURCE/files.html
cp $SOURCE/header.xml $OUTPUT/rss.xml

_texgrep() { grep -m 1 "$1" "$2" | grep -o "{.*}" | sed -e 's/{//; s/}//' ;}
DATED="$(grep -o '<a href=".* ">' $OUTPUT/index.html | sed -e 's/<a href="//; s/\.html ">//')"
for file in $DATED; do
	printf "Compiling \033[0;32m"$file".tex\033[0m\n"
	TITLE="$(_texgrep "title" "$file".tex)"
	DATE="$(_texgrep "date" "$file".tex)"
	PUBDATE="$(date -d "$DATE" +"%a, %d %b %Y")"
	AUTHOR="$(_texgrep "author" "$file".tex)"
	pandoc "$file.tex" -f latex --webtex="https://latex.codecogs.com/svg.latex?" -t html -s -o "$OUTPUT/$file.html" --css=$CSS

	#construct RSS
	printf "Adding \033[0;32m"$file".html\033[0m to RSS feed\n"
	printf "
<item>
<title>$TITLE</title>
<guid>$BLOGURL/$file.html</guid>
<pubDate>$PUBDATE</pubDate>
<description><![CDATA[
$(cat $OUTPUT/$file.html)
]]></description>
</item>
" >> $OUTPUT/rss.xml
done

printf "</channel>\n</rss>" >> $OUTPUT/rss.xml
