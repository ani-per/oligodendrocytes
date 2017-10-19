FILENAME="$1"

# TODO delete Bonuses line? delete tiebreaker instructions?
# TODO remove PGs and (*) in less naive way
textutil -convert txt $FILENAME -stdout \
	| sed '1,/Tossups/d' \
	| perl -CSD -pe 's/\x{2028}|\x0c/\n/g' \
	| sed -E 's/^ANSWER: .*|^[0-9]+\. |For 10 points each:|\[10] //g' \
	| perl -pe 's/\s[\(\[](?!(?:this|these|his|here|one|do|\d) )[^\)\]]+[\)\]]//g'

# tregex.sh -f -n -w -s -i experiments/nlp-parsing/tregex-queries/1.txt -e parsed experiments/nlp-parsing/ > trees.txt
# perl -pe 's/(?<=\()(SBAR|S)\b/\1 [\1/g; s/\(\S+ |\)//g; s!^#.*/([^.]+)[^/]+$!\1\t!g; s/(\d+): (\[S )?//g' trees.txt

# TODO 1 ignore called, named
# TODO 2 ignore if in quotes/italics
