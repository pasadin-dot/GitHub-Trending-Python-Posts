#!/bin/bash

# Path to XAMPP MySQL on Ubuntu
MYSQL="/mnt/c/xampp/mysql/bin/mysql.exe"

#Xampp Setup
USER="root"
DB_NAME="github_trends"
TABLE_NAME="repo"

REPO_LIST="./repo_list.txt"

echo "Inserting data to repo..."
while IFS= read -r REPO_NAME; do
        REPO_NAME="$(echo "$REPO_NAME" | tr -d '\r\n' | xargs | cut -d'/' -f2-)"

        read -r -d '' SQL << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        repo_name_id INT AUTO_INCREMENT PRIMARY KEY,
        repo_name VARCHAR(100) UNIQUE
) AUTO_INCREMENT = 200;

INSERT INTO $TABLE_NAME (repo_name) VALUES ("$REPO_NAME");
EOF

# Note: NO password flag (-p) because root password is empty
echo "$SQL" | "$MYSQL" -h 127.0.0.1 -u "$USER"

done < "$REPO_LIST"

echo "Done inserting data into repo"




