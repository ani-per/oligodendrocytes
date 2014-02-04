DIR=${1%/*}
THIS=${1%.edges}
#QBML=$THIS.qbml
THIS=${THIS##*/}
#NEXT=$(awk "/$THIS/ { if (getline); print }" order.txt)
NEXT=$(awk "/$THIS/ { print line; } { line = \$0 } " order.txt)
PREV_QBML=$DIR/$PREV.qbml
THIS_EDGES=$1
echo $DIR
echo $THIS
echo $PREV_QBML
echo $PREV
echo $THIS_EDGES

# TODO fix whitepsace
XSLT="xsltproc transformers/qbml-to-latex.xsl -"
printf '\\newcommand\lastpacketname{'                                         > $THIS_EDGES
xpath "$PREV_QBML" "translate(string(//packet/@name), '\n', '')" 2>/dev/null >> $THIS_EDGES
printf '}\n\\newcommand\lastpacketone{'                                      >> $THIS_EDGES
xpath "$PREV_QBML" "//tossup[1]/answer"  2>/dev/null | $XSLT                 >> $THIS_EDGES
printf '}\n\\newcommand\lastpackettwenty{'                                   >> $THIS_EDGES
xpath "$PREV_QBML" "//tossup[20]/answer" 2>/dev/null | $XSLT                 >> $THIS_EDGES
printf '}\n'                                                                 >> $THIS_EDGES
