#!/bin/bash

# Path to XAMPP MySQL on Windows
MYSQL="/mnt/c/xampp/mysql/bin/mysql.exe"

# Xampp Setup
USER="root"
DB_NAME="github_trends"
TABLE_NAME="repo_info"

# Read repo_list.txt and repo_desc.txt simultaneously
REPO_LIST="./repo_list.txt"
DESC_FILE="./repo_desc.txt"

paste "$REPO_LIST" "$DESC_FILE" | while IFS=$'\t' read -r REPO_LINE DESC_LINE; do
	# Extract owner name from repo line (format: owner/repo)
	REPO_LINE_CLEAN=$(echo "$REPO_LINE" | tr -d '\r\n' | xargs)
	REPO_NAME=$(echo "$REPO_LINE_CLEAN" | cut -d'/' -f2-)
	OWNER_NAME=$(echo "$REPO_LINE_CLEAN" | cut -d'/' -f1)

	# Extract description from desc line
    	DESC=$(echo "$DESC_LINE" | awk '{$1=""; sub(/^ /,""); print}')
   	DESC_CLEAN=$(echo "$DESC" | tr -d '\r\n' | xargs)

	# Check if any value is empty
    	if [ -z "$OWNER_NAME" ] || [ -z "$REPO_NAME" ] || [ -z "$DESC_CLEAN" ]; then
        	echo "Skipping line - missing data"
        	continue
    	fi

	read -r -d '' SQL << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

-- Get owner_id from owner table
SET @owner_id := (SELECT owner_id FROM owner WHERE owner_name = "$OWNER_NAME");

-- Get repo_name_id from repo table
SET @repo_name_id := (SELECT repo_name_id FROM repo WHERE repo_name = "$REPO_NAME");

-- Get desc_id from description table
SET @desc_id := (SELECT desc_id FROM description WHERE description = "$DESC_CLEAN");

-- Create repo_info table if it doesn't exist
CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    repo_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    repo_name_id INT NOT NULL,
    desc_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
    FOREIGN KEY (repo_name_id) REFERENCES repo(repo_name_id),
    FOREIGN KEY (desc_id) REFERENCES description(desc_id)
) AUTO_INCREMENT = 1;

-- Insert into repo_info if all foreign keys exist
INSERT INTO $TABLE_NAME (owner_id, repo_name_id, desc_id) 
SELECT @owner_id, @repo_name_id, @desc_id
WHERE @owner_id IS NOT NULL 
  AND @repo_name_id IS NOT NULL 
  AND @desc_id IS NOT NULL;
EOF

	# Note: NO password flag (-p) because root password is empty
    	echo "$SQL" | "$MYSQL" -h 127.0.0.1 -u "$USER"

done

echo "Done inserting values into REPO_INFO table"
