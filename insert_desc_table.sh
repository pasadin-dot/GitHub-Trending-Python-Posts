#!/bin/bash

# Path to XAMPP MySQL on Windows
MYSQL="/mnt/c/xampp/mysql/bin/mysql.exe"

#Xampp Setup
USER="root"
DB_NAME="github_trends"
TABLE_NAME="description"

DESC_FILE="./repo_desc.txt"



while IFS= read -r LINE; do
        DESC=$(echo "$LINE" | awk '{$1=""; sub(/^ /,""); print}')

        read -r -d '' SQL << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        desc_id INT AUTO_INCREMENT PRIMARY KEY,
        description TEXT UNIQUE
) AUTO_INCREMENT = 300;

INSERT INTO $TABLE_NAME (description) VALUES ("$DESC");
EOF

# Note: NO password flag (-p) because root password is empty
echo "$SQL" | "$MYSQL" -h 127.0.0.1 -u "$USER"

done < "$DESC_FILE"

echo "Done inserting values into REPO table"
