#!/bin/bash

set -e  # Exit immediately if a command fails
set -u  # Exit if an undefined variable is used
set -o pipefail  # Exit if any command in a pipeline fails

MOUNT_SOURCE="$HOME/.local/share/waydroid/data/media/0/Android/data/org.telegram.messenger.web/files/Telegram/Telegram\ Video"
MOUNT_TARGET="/data/hdd/Android/Telegram"

# Check if the source directory exists
if [ ! -d "$MOUNT_SOURCE" ]; then
    echo "Error: Source directory does not exist: $MOUNT_SOURCE" >&2
    exit 1
fi

# Check if the target directory exists
if [ ! -d "$MOUNT_TARGET" ]; then
    echo "Error: Target directory does not exist: $MOUNT_TARGET" >&2
    exit 1
fi

# Bind mount the directory
if sudo mount --bind "$MOUNT_SOURCE" "$MOUNT_TARGET"; then
    echo "Mount successful: $MOUNT_SOURCE -> $MOUNT_TARGET"
else
    echo "Error mounting the directory" >&2
    exit 1
fi

# Modify permissions and ownership
if sudo chmod -R 777 "$MOUNT_TARGET" && sudo chown -R pedrokw:users "$MOUNT_TARGET"; then
    echo "Permissions and ownership adjusted successfully."
else
    echo "Error adjusting permissions and ownership" >&2
    exit 1
fi

