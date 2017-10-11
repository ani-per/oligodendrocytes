set -e

if [ $# -ne 5 ]; then
    echo "Need 5 arguments"
    exit 0
fi

if [ -z "$3" ]; then
	echo "Need argument 3 folder name"
	exit 0
fi

echo "fetching docs into $1"
mkdir -p $1
skicka download -download-google-apps-files "$3" "$1"

echo
echo "changing filenames and copying into $2"
for i in $1*; do
    FILENAME=${i##*\/}
    NEWNAME=${FILENAME:$4:$5}
    if [ ! -z "$NEWNAME" ]; then
        NEWPATH=$2$NEWNAME.docx
        printf "copying %-42s → \"$NEWNAME\"\n" "\"$FILENAME\""
        cp "$i" "$NEWPATH" || true
    fi
done
## and this
#echo "removing Fi.docx"
#rm Fi.docx
