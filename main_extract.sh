#!/bin/bash

# Retrieve current date and time
DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M:%S")
DATETIME=$(date +"%Y-%m-%d %H:%M:%S")

URL="https://github.com/trending/python?since=daily&spoken_language_code=en"
BASE_DIR="/home/user/Coursework_1"

# Count number of times website was curled on the current day
COUNT=$(ls "$BASE_DIR/${DATE}"_*.html 2>/dev/null | wc -l)
NUM=$((COUNT + 1))

CURLED_FILE="$BASE_DIR/${DATE}_${NUM}.html"
echo "[+] Fetching GitHub Page..."
curl -s "$URL" > "$CURLED_FILE"
echo "[+] Saved HTML: $CURLED_FILE"

OUTPUT_FILE="$BASE_DIR/data.txt"

while IFS= read -r REPO_NAME; do
	# Remove any \r \n and spaces 
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"

	echo "=============================="
	echo "Repository: $REPO_NAME"
	echo "=========================="
	
	# Get owner name and repo 
	OWNER=$(echo "$REPO_NAME" | awk -F '/' '{print $1}')
	REPO=$(echo "$REPO_NAME" | awk -F '/' '{print $2}')

	# 1. Locate match row
	LINE=$(grep -n "href=\"/$REPO_NAME\"" "$CURLED_FILE" | head -1 | cut -d: -f1)

	# 2. If not found, skip
	if [ -z "$LINE" ]; then
		echo "Repo not found in HTML. Skipping."
		continue
	fi

	# 3. Extract Stars
	STAR_ROW=$((LINE+23))
	STAR=$(sed -n "${STAR_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

	# 4. Extract Forks
	FORK_ROW=$((LINE+27))
	FORK=$(sed -n "${FORK_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
	
	echo "Owner: $OWNER"
	echo "Repo: $REPO"
	echo "Stars: $STAR"
	echo "Forks: $FORK"
	echo ""

	printf "%-20s %-15s %-7s %-7s %s\n" "$OWNER" "$REPO" "$STAR" "$FORK" "$DATETIME" >> "$OUTPUT_FILE"


done < "$BASE_DIR/repo_list.txt"
