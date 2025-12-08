#!/bin/bash

BASE_DIR="/home/user/Coursework_1"
STARDATA_FILE="$BASE_DIR/star_data/psf_black_star.txt"
STAR_OUTPUT_FILE="test_graph.png"

gnuplot << EOF
set terminal pngcairo size 1200,800 enhanced font 'Arial,12'
set output '$STAR_OUTPUT_FILE'
set datafile separator whitespace
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M\n%m/%d"
set xlabel "Time"
set ylabel "Star Count"
set title "GitHub Star Count for psf/black"
set grid
plot '$STARDATA_FILE' using 2:1 with linespoints lc rgb "#2ca02c" lw 2 pt 2 ps 2 title "psf/black"
EOF

echo "[+] Graph saved as $STAR_OUTPUT_FILE"
