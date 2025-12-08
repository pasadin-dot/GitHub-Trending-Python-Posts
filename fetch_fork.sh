#!/bin/bash

FORKDATA_DIR="./fork_data"
DATA_FILE="./data.txt"

if [ ! -d "$FORKDATA_DIR" ]; then
	echo "'fork_data' directory does not exit. Creating it..."
	mkdir -p "$FORKDATA_DIR"
	echo "'fork_data' directory created."
	echo ""
fi

while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	OWNER="${REPO_NAME%%/*}"
	REPO="${REPO_NAME##*/}"

	echo "[+] Fetching forks from $REPO_NAME..."
	grep "$OWNER" "$DATA_FILE" | awk '{print $4" "$5" "$6}' > "$FORKDATA_DIR/${OWNER}_${REPO}_fork.txt"

done < "./repo_list.txt"
