#!/usr/bin/env bash

# Define variables
TIMESTAMP=$(date +%Y%m%d%H%M%S)
VERSION="10.10.3.0"
BACKUP_DIR="/data/hdd/Files/Backups/"
DEST_DIR="${BACKUP_DIR}/jellyfin.${TIMESTAMP}_${VERSION}"

# Create the backup directory
mkdir -p ${DEST_DIR}

# Copy Jellyfin data and configuration
echo "Starting data backup..."
sudo cp -av /var/lib/jellyfin ${DEST_DIR}/data

echo "Starting config backup..."
sudo cp -av /etc/jellyfin ${DEST_DIR}/config

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
else
    echo "Error performing backup!" >&2
    exit 1
fi
