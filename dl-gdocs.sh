set -e

if [ $# -ne 4 ]; then
    echo "Need 4 arguments"
    exit 0
fi

PACKETS_DIR="$1"                # packets/
GDOCS_FOLDER_NAME="$2"
PACKET_FILENAME_TO_SLUG_START="$3"
PACKET_FILENAME_TO_SLUG_LENGTH="$4"

if [ -z "$GDOCS_FOLDER_NAME" ]; then
    echo "Need Google Drive folder name"
    exit 0
fi

DOCS_DIR="$PACKETS_DIR"docs/    # packets/docs/

echo "fetching docs into $DOCS_DIR"
mkdir -p $DOCS_DIR
skicka download -download-google-apps-files "$GDOCS_FOLDER_NAME" "$DOCS_DIR"

echo
echo "changing filenames and copying into $PACKETS_DIR"
for DOC in $DOCS_DIR*; do
    OLDNAME=${DOC##*\/}
    NEWNAME=${OLDNAME:$PACKET_FILENAME_TO_SLUG_START:$PACKET_FILENAME_TO_SLUG_LENGTH}
    if [ ! -z "$NEWNAME" ]; then
        NEWPATH=$PACKETS_DIR$NEWNAME.docx
        printf "copying %-42s → \"$NEWNAME\"\n" "\"$OLDNAME\""
        cp "$DOC" "$NEWPATH" || true
    fi
done
