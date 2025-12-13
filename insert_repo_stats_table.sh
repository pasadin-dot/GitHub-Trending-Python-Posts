#!/bin/bash

# Path to XAMPP MySQL on Ubuntu
MYSQL="/mnt/c/xampp/mysql/bin/mysql.exe"

# Xampp Setup
USER="root"
DB_NAME="github_trends"
TABLE_NAME="repo_stats"

DATA_FILE="./data.txt"

echo "Inserting data into repo_stats..."
while IFS== read -r LINE; do
	#Extract datas in data.txt
	OWNER=$(echo "$LINE" | awk '{print $1}')
	REPO_NAME=$(echo "$LINE" | awk '{print $2}')
	NUM_STARS=$(echo "$LINE" | awk '{print $3}')
	NUM_FORKS=$(echo "$LINE" | awk '{print $4}')
	TIMESTAMP=$(echo "$LINE" | awk '{print $5, $6}')
	
	# Check if any value is empty
	if [ -z "$OWNER" ] || [ -z "$REPO_NAME" ] || [ -z "$NUM_STARS" ] || [ -z "$NUM_FORKS" ] || [ -z "$TIMESTAMP" ]; then
    		echo "Skipping line - missing data"
    		continue
	fi

	read -r -d '' SQL << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

-- Get owner_id from owner table
SET @owner_id := (SELECT owner_id FROM owner WHERE owner_name = "$OWNER");

-- Get repo_name_id from repo table
SET @repo_name_id := (SELECT repo_name_id FROM repo WHERE repo_name = "$REPO_NAME");

-- Get repo_id from repo_info table
SET @repo_id := (
	SELECT repo_id 
	FROM repo_info 
	WHERE owner_id = @owner_id 
	AND repo_name_id = @repo_name_id
	);

--Create repo_stats table if it doesn't exist
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
	repo_id INT,
	datetime_collected DATETIME,
	num_stars INT,
	num_forks INT,
	PRIMARY KEY (repo_id, datetime_collected),
	FOREIGN KEY (repo_id) REFERENCES repo_info(repo_id)
	);

-- Add composite UNIQUE constraint to prevent duplicate owner/repo/desc combinations
ALTER TABLE $TABLE_NAME
ADD UNIQUE unique_repo_stats_combo (repo_id, datetime_collected);

-- Insert into repo_stats if all foreign key exist
INSERT INTO $TABLE_NAME (repo_id, datetime_collected, num_stars, num_forks)
SELECT @repo_id, '$TIMESTAMP', $NUM_STARS, $NUM_FORKS
WHERE @repo_id IS NOT NULL;
EOF

	# Note: NO password flag (-p) because root password is empty
        echo "$SQL" | "$MYSQL" -h 127.0.0.1 -u "$USER"

done < "$DATA_FILE"

echo "Done inserting data into repo_stats"
