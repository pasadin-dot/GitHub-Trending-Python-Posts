#!/bin/bash
REPO_NAME="modelscope/FunASR"

LINE=$(grep -n "href=\"/$REPO_NAME\"" git_webpage.html | head -1 | cut -d: -f1)
STAR_ROW=$((LINE+23))
sed -n "${STAR_ROW}p" git_webpage.html
