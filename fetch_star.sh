#!/bin/bash

STARDATA_DIR="./star_data"
DATA_FILE="./data.txt"

if [ ! -d "$STARDATA_DIR" ]; then
	echo "'star_data' directory does not exist. Creating it..."
	mkdir -p "$STARDATA_DIR"
	echo "'star_data' directory created."
	echo ""
fi

while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	OWNER="${REPO_NAME%%/*}"
	REPO="${REPO_NAME##*/}"

	echo "[+] Fetching stars from $REPO_NAME..."
	grep "$OWNER" "$DATA_FILE" | awk '{print $3" "$5" "$6}' > "$STARDATA_DIR/${OWNER}_${REPO}_star.txt"

done < "./repo_list.txt"
