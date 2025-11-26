#!/bin/bash

CURLED_FILE="git_webpage.html"

echo "Reading description..."
while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	echo "=============================="
	echo "Repository: $REPO_NAME"
	echo "=========================="
	
	#Locate match row
	LINE=$(grep -n "href=\"/$REPO_NAME\"" "$CURLED_FILE" | head -1 | cut -d: -f1)

	#If not found, skip
	if [ -z "$LINE" ]; then
		echo "Repo not found in HTML. Skipping."
		continue
	fi

	#Extract Description 
	DESC_ROW=$((LINE+10))
	DESC=$(sed -n "${DESC_ROW}p" "$CURLED_FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

	echo "Description: $DESC"
	echo ""

	printf "%-40s %s\n" "$REPO_NAME" "$DESC" >> repo_desc.txt
done < repo_list.txt
