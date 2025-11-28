#!/bin/bash

BASE_DIR="/home/user/Coursework_1"
STARGRAPH_DIR="$BASE_DIR/star_graph"
STARDATA_DIR="$BASE_DIR/star_data"

# Plot star graph
while IFS= read -r REPO_NAME; do
	REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"

	echo "[+] Creating graph..."
	OWNER="${REPO_NAME%%/*}"
	REPO="${REPO_NAME##*/}"
	echo "Owner: $OWNER"
	echo "Repo: $REPO"

	# Remove '/' for $REPO_NAME
	REPO_CLEANED=$(echo "$REPO_NAME" | tr -d '/')

	OUTPUT_FILE="$STARGRAPH_DIR/${REPO_CLEANED}_star_graph.png"
	DATA_FILE="$STARDATA_DIR/${OWNER}_${REPO}_star.txt"
	
	# Check if the data file exists
    	if [[ ! -f "$DATA_FILE" ]]; then
        	echo "[-] Data file $DATA_FILE not found. Skipping."
        	continue
    	fi

	gnuplot << EOF
set terminal pngcairo size 1200,800 enhanced font 'Arial,12'
set output '$OUTPUT_FILE'
set datafile separator whitespace
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M\n%m/%d"
set xlabel "Time"
set ylabel "Star Count"
set title "GitHub Star Count for $REPO_NAME"
set grid
plot '$DATA_FILE' using 2:1 with linespoints title "$REPO_NAME"
EOF

	echo "[+] Graph saved as $OUTPUT_FILE"
done < "$BASE_DIR/repo_list.txt"
