#!/bin/bash

#Set curled file as any .html file in the current directory
CURLED_FILE=$(ls *.html 2>/dev/null | head -n 1)

OUTPUT_FILE="./repo_desc.txt"

#Create 'repo_desc.txt' if does not exist
if [ ! -f "$OUTPUT_FILE" ]; then
	echo "'repo_desc.txt' does not exist in current directory. Creating 'repo_desc.txt'..."
	touch "$OUTPUT_FILE"
	echo "'repo_desc.txt' created successfully"
	echo ""
fi

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
	
	#Store data in 'repo_desc,txt'
	printf "%-40s %s\n" "$REPO_NAME" "$DESC" >> "$OUTPUT_FILE"
done < repo_list.txt

