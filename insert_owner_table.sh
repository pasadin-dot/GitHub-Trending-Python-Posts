#!/bin/bash

# Path to XAMPP MySQL on Windows
MYSQL="/mnt/c/xampp/mysql/bin/mysql.exe"

#Xampp Setup
USER="root"
DB_NAME="github_trends"
TABLE_NAME="owner"

REPO_LIST="./repo_list.txt"

while IFS= read -r REPO_NAME; do
        REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs)"
	OWNER_NAME="${REPO_NAME%%/*}"

	read -r -d '' SQL << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        owner_id INT AUTO_INCREMENT PRIMARY KEY,
        owner_name VARCHAR(100) UNIQUE
) AUTO_INCREMENT = 100;

INSERT INTO $TABLE_NAME (owner_name) VALUES ("$OWNER_NAME");
EOF

# Note: NO password flag (-p) because root password is empty
echo "$SQL" | "$MYSQL" -h 127.0.0.1 -u "$USER"

done < "$REPO_LIST"

echo "Done inserting values into OWNER table"
