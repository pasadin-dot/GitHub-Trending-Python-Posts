#!/bin/bash

CURLED_FILE="git_webpage.html"

while IFS= read -r REPO_NAME; do
    REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
    echo "=============================="
    echo "Repository: $REPO_NAME"
    echo "=========================="

    # 1. Locate match row
    LINE=$(grep -n "href=\"/$REPO_NAME\"" "$CURLED_FILE" | head -1 | cut -d: -f1)

    # 2. If not found, skip
    if [ -z "$LINE" ]; then
        echo "Repo not found in HTML. Skipping."
        continue
    fi

    # 3. Extract Stars
    STAR_ROW=$((LINE+23))
    STAR=$(sed -n "${STAR_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',')

    # 4. Extract Forks
    FORK_ROW=$((LINE+27))
    FORK=$(sed -n "${FORK_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',')

    echo "Stars: $STAR"
    echo "Forks: $FORK"
    echo ""

done < repo_list.txt

