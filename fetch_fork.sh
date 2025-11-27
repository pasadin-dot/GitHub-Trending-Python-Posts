#!/bin/bash

BASE_DIR="/home/user/Coursework_1"
FORK_DIR="/home/user/Coursework_1/fork_data"
DATA_FILE="$BASE_DIR/try.txt"

while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	OWNER="${REPO_NAME%%/*}"
	REPO="${REPO_NAME##*/}"

	echo "[+] Fetching forks from $REPO_NAME..."
	grep "$OWNER" "$DATA_FILE" | awk '{print $4" "$5" "$6}' > "$FORK_DIR/$OWNER_$REPO_fork.txt"

done < "$BASE_DIR/repo_list.txt
