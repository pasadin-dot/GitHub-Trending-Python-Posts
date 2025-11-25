#!/bin/bash
REPO_NAME="modelscope/FunASR"
CURLED_FILE="git_webpage.html"

LINE=$(grep -n "href=\"/$REPO_NAME\"" git_webpage.html | head -1 | cut -d: -f1)
STAR_ROW=$((LINE+23))
STAR=$(sed -n "${STAR_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',') 

FORK_ROW=$((LINE+27))
FORK=$(sed -n "${FORK_ROW}p" "$CURLED_FILE" | awk -F '</a>' '{print $1}' | tr -d ',')

echo "Stars: $STAR"
echo "Fork: $FORK" 
