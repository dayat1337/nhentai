#!/bin/bash
# makasih buat lo semua ya ngentot, gue masih stay disini anjiing!!
if [[ -z "$1" ]]; then
    echo "usage: ""$0"" <nhentai url, https://nhentai.net/g/070601/ etc.>"
    exit 1;
fi
URL="https:\/\/i.nhentai.net\/galleries\/"
DATA=$(curl -s "$1" -o -)
PAGE_COUNT=$(echo "$DATA" | grep -Eo "<div>[0-9]+ pages</div>" | tr -dc '0-9')
GALLERY_ID=$(echo "$DATA" | grep -Eo -m 1 "[0-9]+/cover" | tr -dc '0-9')
EXT=$(echo "$DATA" | grep -Eo "/galleries/[0-9]+/1t.[a-z]+" | sed 's/^.*\/1t//' | head -1)
DIR1=$(echo "$DATA" | grep -Eo "<h1>[^<]+</h1>" | sed 's/^....//;s/.....$//' | tr -dc 'a-zA-Z0-9 '| sed 's/\(\s\s*\)/_/g;s/^.\{100\}//')
DIR2=$(echo "$1" | sed 's/^.*g.\(.*\).$/_nhentai\1/')
DIR3=$(echo "$DIR1""$DIR2" | sed 's/\(\s\s*\)/_/g')

echo "Downloading doujin into ""$DIR3"", ""$PAGE_COUNT"" pages."
echo "This might take a while.."

PREV=$(pwd)

mkdir -p "$DIR3" && cd "$DIR3"

seq 1 "$PAGE_COUNT" | sed 's/^/'"$(echo $URL)"''"$(echo $GALLERY_ID)"'\//;s/$/.jpg/' \
| xargs -n 1 -P16 wget -q -nc --accept "*.jpg"

seq 1 "$PAGE_COUNT" | sed 's/^/'"$(echo $URL)"''"$(echo $GALLERY_ID)"'\//;s/$/.png/' \
| xargs -n 1 -P16 wget -q -nc --accept "*.png"
# retards like to mix .jpg and .png in the same doujin *smh*    

cd "$PREV"
