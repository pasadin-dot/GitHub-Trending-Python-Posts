#!/bin/bash

FORKGRAPH_DIR="./fork_graph"
FORKDATA_DIR="./fork_data"

#Create 'fork_graph' directory if does not exist
if [ ! -d "$FORKGRAPH_DIR" ]; then
        echo "'fork_graph' directory does not exist. Creating it..."
        mkdir -p "$FORKGRAPH_DIR"
        echo "'fork_graph' directory created."
        echo ""
fi

#Exit code if 'fork_data' directory does not exist
if [ ! -d "$FORKDATA_DIR" ]; then
        echo "'fork_data' directory does not exist. Please run 'fetch_fork.sh' first."
        echo "Code exiting..."
        exit 1
fi

# Plot fork graph
while IFS= read -r REPO_NAME; do
        REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"

        echo "[+] Creating graph..."
        OWNER="${REPO_NAME%%/*}"
        REPO="${REPO_NAME##*/}"

        # Remove '/' for $REPO_NAME
        REPO_CLEANED=$(echo "$REPO_NAME" | tr -d '/')

        OUTPUT_FILE="$FORKGRAPH_DIR/${REPO_CLEANED}_fork_graph.png"
        DATA_FILE="$FORKDATA_DIR/${OWNER}_${REPO}_fork.txt"

        # Check if the data file exists
        if [[ ! -f "$DATA_FILE" ]]; then
                echo "[-] Data file $DATA_FILE not found. Skipping."
                continue
        fi
	
	#Plot graph
        gnuplot << EOF
set terminal pngcairo size 1200,800 enhanced font 'Arial,12'
set output '$OUTPUT_FILE'
set datafile separator whitespace
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M\n%m/%d"
set xlabel "Time"
set ylabel "Fork Count"
set title "GitHub Fork Count for $REPO_NAME"
set grid
plot '$DATA_FILE' using 2:1 with linespoints title "$REPO_NAME"
EOF

        echo "[+] Graph saved as $OUTPUT_FILE"
done < "./repo_list.txt"

