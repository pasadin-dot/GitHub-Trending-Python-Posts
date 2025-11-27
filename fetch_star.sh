#!/bin/bash

BASE_DIR="/home/user/Coursework_1"
STAR_DIR="/home/user/Coursework_1/star_data"
DATA_FILE="$BASE_DIR/try.txt"

while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	OWNER="${REPO_NAME%%/*}"
	REPO="${REPO_NAME##*/}"

	echo "[+] Fetching stars from $REPO_NAME..."
	grep "$OWNER" "$DATA_FILE" | awk '{print $3" "$5" "$6}' > "$STAR_DIR/$OWNER_$REPO_star.txt"

done < "$BASE_DIR/repo_list.txt"
